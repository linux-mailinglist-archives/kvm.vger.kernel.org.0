Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E3C4D0005
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 14:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242863AbiCGN2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 08:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237420AbiCGN2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 08:28:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F89E8BF1B;
        Mon,  7 Mar 2022 05:27:23 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227CovUk011559;
        Mon, 7 Mar 2022 13:27:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=9Xs1+iRscnxalmm+QWUBm4v/2ipilHWpYzFSRmzQuE4=;
 b=KgIxQj40lAFrL/mTjT90VfeGBQuJ5NxG7hzFZaDiiok/UxeI+fxP16MsJvT0va6mjaY5
 J9zhx//B4X7ZBafeHnshjWA285GD0KahsJE+aDNYPQJPLJ7qJhc2pNyodnBXDBtY7ext
 nLLgxGJABm/ZL2IzTcg7THxJmE9eXrhcYfOIakaf1mdcf+77zr0Z+2OAGf5BIPVVjYT2
 Dpm8kMwoMmtyzlETP86U9Zv6J6j19kbfnLxVvttqfw7z/JdXBioag9yezzDc6gTaGWk9
 XFhZiTAF00FElfw1u7SYriArGoqo8eXemSM8C43M/gTJiFkBCXI6V3J1UikNdvtvH1NW mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3end6fyd2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 13:27:20 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227DRKbN006511;
        Mon, 7 Mar 2022 13:27:20 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3end6fyd1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 13:27:20 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227DCw0U010197;
        Mon, 7 Mar 2022 13:27:17 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3eky4hvsyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 13:27:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227DRE3l41812332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 13:27:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 667E34C04A;
        Mon,  7 Mar 2022 13:27:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF7C54C044;
        Mon,  7 Mar 2022 13:27:13 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.73.209])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon,  7 Mar 2022 13:27:13 +0000 (GMT)
Date:   Mon, 7 Mar 2022 14:27:11 +0100
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
Message-ID: <20220307142711.5af33ece.pasic@linux.ibm.com>
In-Reply-To: <9ac3908e-06da-6276-d1df-94898918fc5b@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
        <20220215005040.52697-9-akrowiak@linux.ibm.com>
        <97681738-50a1-976d-9f0f-be326eab7202@linux.ibm.com>
        <9ac3908e-06da-6276-d1df-94898918fc5b@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vXZ-5ZoGv8gC9JSVNAOvIWNDczue8gZe
X-Proofpoint-GUID: WCccG6fkHYA87iWWq4ky5tfjAr1HYwTd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_05,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 clxscore=1011 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Mar 2022 07:31:21 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 3/3/22 10:39, Jason J. Herne wrote:
> > On 2/14/22 19:50, Tony Krowiak wrote:  
> >>   /**
> >> - * vfio_ap_mdev_verify_no_sharing - verifies that the AP matrix is 
> >> not configured
> >> + * vfio_ap_mdev_verify_no_sharing - verify APQNs are not shared by 
> >> matrix mdevs
> >>    *
> >> - * @matrix_mdev: the mediated matrix device
> >> + * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
> >> + * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
> >>    *
> >> - * Verifies that the APQNs derived from the cross product of the AP 
> >> adapter IDs
> >> - * and AP queue indexes comprising the AP matrix are not configured 
> >> for another
> >> + * Verifies that each APQN derived from the Cartesian product of a 
> >> bitmap of
> >> + * AP adapter IDs and AP queue indexes is not configured for any matrix
> >>    * mediated device. AP queue sharing is not allowed.
> >>    *
> >> - * Return: 0 if the APQNs are not shared; otherwise returns 
> >> -EADDRINUSE.
> >> + * Return: 0 if the APQNs are not shared; otherwise return -EADDRINUSE.
> >>    */
> >> -static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev 
> >> *matrix_mdev)
> >> +static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
> >> +                      unsigned long *mdev_aqm)
> >>   {
> >> -    struct ap_matrix_mdev *lstdev;
> >> +    struct ap_matrix_mdev *matrix_mdev;
> >>       DECLARE_BITMAP(apm, AP_DEVICES);
> >>       DECLARE_BITMAP(aqm, AP_DOMAINS);
> >>   -    list_for_each_entry(lstdev, &matrix_dev->mdev_list, node) {
> >> -        if (matrix_mdev == lstdev)
> >> +    list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
> >> +        /*
> >> +         * If the input apm and aqm belong to the matrix_mdev's matrix,

How about:

s/belong to the matrix_mdev's matrix/are fields of the matrix_mdev
object/


> >> +         * then move on to the next.
> >> +         */
> >> +        if (mdev_apm == matrix_mdev->matrix.apm &&
> >> +            mdev_aqm == matrix_mdev->matrix.aqm)
> >>               continue;  
> >
> > We may have a problem here. This check seems like it exists to stop 
> > you from
> > comparing an mdev's apm/aqm with itself. Obviously comparing an mdev's 
> > newly
> > updated apm/aqm with itself would cause a false positive sharing 
> > check, right?
> > If this is the case, I think the comment should be changed to reflect 
> > that.  
> 
> You are correct, this check is performed to prevent comparing an mdev to
> itself, I'll improve the comment.
> 
> >
> > Aside from the comment, what stops this particular series of if 
> > statements from
> > allowing us to configure a second mdev with the exact same apm/aqm 
> > values as an
> > existing mdev? If we do, then this check's continue will short circuit 
> > the rest
> > of the function thereby allowing that 2nd mdev even though it should be a
> > sharing violation.  
> 
> I don't see how this is possible.

I agree with Tony and his explanation.

Furthermore IMHO is relates to the class identity vs equality problem, in
a sense that identity always implies equality.

Regards,
Halil
