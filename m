Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2047E53FE47
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 14:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243357AbiFGMGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 08:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240340AbiFGMGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 08:06:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12ABF5534;
        Tue,  7 Jun 2022 05:06:00 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257BSfaS019178;
        Tue, 7 Jun 2022 12:05:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=XTeQ+dQstEypyto2xBeV0JnMoP1Xt5ItKNMp4LQKRpk=;
 b=dgMb0G5Xar93sIp4VySX/1w68CspO6FO1zEuqB++Pi2RFBb33WxgrYzcGgDfSkMR9hM5
 P6IE0tIsyreW1dK+naD4Yl+LDMUtszP7dml1J0pX9wtZ7UMTD+A+6kahD06aeDgnu8CM
 g52meEZ+A/phzNQDes192lG//H+KDNapxLgiENKSYZrSVElbonweeL7R01PM7VvJu9nk
 ivWhWkoeKtYxOWGNqOrFgegE8Zzw8nPmCVk9zQ5Q+NpVmk/uTsD24hUgzutkClb/vLMX
 6/Z1VCulkFCLTOzHMU1/I4kTg3KhXEqOQQbZnuZnoCxt0fFTrdR0IQ2OgWr3kBNLHvB6 SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj5u38ncq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 12:05:58 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 257BVjrj031205;
        Tue, 7 Jun 2022 12:05:58 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj5u38nbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 12:05:58 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 257C5dJW014828;
        Tue, 7 Jun 2022 12:05:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3gfy19bqmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 12:05:56 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 257C5rWJ31064368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jun 2022 12:05:53 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E86111C071;
        Tue,  7 Jun 2022 12:05:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BE3911C06F;
        Tue,  7 Jun 2022 12:05:52 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.16.221])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue,  7 Jun 2022 12:05:52 +0000 (GMT)
Date:   Tue, 7 Jun 2022 14:05:44 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v19 11/20] s390/vfio-ap: prepare for dynamic update of
 guest's APCB on queue probe/remove
Message-ID: <20220607140544.32d33f3d.pasic@linux.ibm.com>
In-Reply-To: <f838f274-ff4d-496d-2393-14423117ff7e@linux.ibm.com>
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
        <20220404221039.1272245-12-akrowiak@linux.ibm.com>
        <9364a1b7-9060-20aa-b0d6-88c41a30e7d4@linux.ibm.com>
        <f838f274-ff4d-496d-2393-14423117ff7e@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FV0JSVpMoOjx3jX8H7Bi5nfXD_pNmkXa
X-Proofpoint-GUID: tADHCpYYpz-awQPvxr_vfJsyJHOnAtkD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_04,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxscore=0 spamscore=0 clxscore=1011 lowpriorityscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 31 May 2022 06:44:46 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> > vfio_ap_mdev_get_update_locks_for_apqn is "crazy long".
> > How about:
> >   get_mdev_for_apqn()
> >
> > This function is static and the terms mdev and apqn are specific 
> > enough that I
> > don't think it needs to start with vfio_ap. And there is no need to 
> > state in
> > the function name that locks are acquired. That point will be obvious 
> > to anyone
> > reading the prologue or the code.  
> 
> The primary purpose of the function is to acquire the locks in the 
> proper order, so
> I think the name should state that purpose. It may be obvious to someone 
> reading
> the prologue or this function, but not so obvious in the context of the 
> calling function.

I agree with Tony. To me get_mdev_for_apqn() sounds like getting a
reference to a matrix_mdev object (and incrementing its refcount) or
something similar. BTW some more bike shedding: I prefer by_apqn instead
of for_apqn, because the set of locks we need to take is determined _by_
the apqn parameter, but it ain't semantically the set of locks we need
to perform an update operation on the apqn or on the queue associated
with the apqn. No strong opinion though -- I'm no native speaker and
prepositions are difficult for me.

Regards,
Halil
