Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35A14D1439
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 11:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345630AbiCHKHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 05:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345621AbiCHKHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 05:07:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217D240915;
        Tue,  8 Mar 2022 02:06:48 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2287j8pb012052;
        Tue, 8 Mar 2022 10:06:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=WPiUHp7Llsw5SNrmHjEwv6thabpRY2uwdIC/chRd+9c=;
 b=IteXf2ofpBG9LbAEPdQhWaJ0pj6HlOTLjD4d8+x+7+e9f9RUnG11sJ+t4+DvqIidPPQK
 2nwMT2aXzMygMpdIOyL00xRV2sYBVzOIqMsDSkBx89HX+6QlDB4qdi4OkNVKCKmmY2p0
 FBz3TBUdeLrvsrcMNru2H93IiBiBD6SyPYsJ/LfDwl8IxKgtlU5pZUxtWzb540JrkuqP
 DSyYbCjGfnSoo6LNraA8JXD8Xn1eWli/4slZfTRz40vOi4zHX42jo0guWed37vcqgaoQ
 2l3Sj3yIVavWpeNwWol+r68AH7DhuTSvlnAK8VKd7yjD3CP3Lig3QJ4ACSXAv59SNuuP 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ep03ve2r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 10:06:46 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2289pSbT027404;
        Tue, 8 Mar 2022 10:06:46 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ep03ve2qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 10:06:45 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 228A33Kc020419;
        Tue, 8 Mar 2022 10:06:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3eky4hy7fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 10:06:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 228A6etH49283388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Mar 2022 10:06:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E42E4C050;
        Tue,  8 Mar 2022 10:06:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2D8C4C040;
        Tue,  8 Mar 2022 10:06:39 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.68.74])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue,  8 Mar 2022 10:06:39 +0000 (GMT)
Date:   Tue, 8 Mar 2022 11:06:37 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v18 08/18] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
Message-ID: <20220308110637.2e839732.pasic@linux.ibm.com>
In-Reply-To: <eb30a519-5707-717a-ff22-cc3a8e65dc7e@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
        <20220215005040.52697-9-akrowiak@linux.ibm.com>
        <97681738-50a1-976d-9f0f-be326eab7202@linux.ibm.com>
        <9ac3908e-06da-6276-d1df-94898918fc5b@linux.ibm.com>
        <20220307142711.5af33ece.pasic@linux.ibm.com>
        <151241e6-3099-4be2-da54-1f0e5cb3a705@linux.ibm.com>
        <20220307181027.29c821b6.pasic@linux.ibm.com>
        <eb30a519-5707-717a-ff22-cc3a8e65dc7e@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: G9yLo1VpFU1J1bzoLhYxh5HJSn66nx17
X-Proofpoint-ORIG-GUID: EtQJUWOuC8QThu3OceJgqNtyPqcbOz5V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_03,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 spamscore=0 clxscore=1015 malwarescore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 phishscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203080053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Mar 2022 18:45:45 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

[..]
> >>> s/belong to the matrix_mdev's matrix/are fields of the matrix_mdev
> >>> object/  
> >> This is the comment I wrote:
> >>
> >>           /*
> >>            * Comparing an mdev's newly updated apm/aqm with itself would
> >>            * result in a false positive when verifying whether any APQNs
> >>            * are shared; so, if the input apm and aqm belong to the
> >>            * matrix_mdev's matrix, then move on to the next one.
> >>            */
> >>
> >> However, I'd be happy to change it to whatever either of you want.  
> > What ain't obvious for the comment is that "belong to" actually means
> > composition and not association. In other words, there there is no
> > pointer/indirection involved, a pointer that would tell us what matrix
> > does belong to what matrix_mdev, but rather the matrix is just a part
> > of the matrix_mdev object.
> >
> > I don't like 'false positive' either, and whether the apm/aqm is
> > newly updated or not is also redundant and confusing in my opinion. When
> > we check because of inuse there is not updated whatever. IMHO the old
> > message was better than this one.
> >
> > Just my opinion, if you two agree, that this is the way to go, I'm fine
> > with that.
> >
> > Regards,
> > Halil  
> 
> Feel free to recommend the verbiage for this comment. I'm not married
> to my comments and am open to anything that helps others to
> understand what is going on here. It seems obvious to me, but I wrote
> the code. Obviously, it is not so obvious based on Jason's comments,
> so maybe someone else can compose a better comment.

/*
* If the input apm and aqm are fields of the matrix_mdev object,
* then move on to the next matrix_mdev.
*/

Regards,
Halil
