Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52964D04FC
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 18:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243258AbiCGRLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 12:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbiCGRLe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 12:11:34 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2C48301E;
        Mon,  7 Mar 2022 09:10:39 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227FIcK1006300;
        Mon, 7 Mar 2022 17:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=nPp+FBrbOyhOFp4k8E3F3lZ4Ca6JUG3oR4oBk3awDZw=;
 b=EGoWmJK5IFUI05HF97e/PHdWkRw9oPCfRNVC0DiF83UHObYk/hmWr4csMz4albrY9U++
 gdEDYgEq94s0ZQ6h64IaC9z3b2OMd97Lji4hP8mD+2IJ8qausl5t8A3SAFyarNkyB/7u
 zQS+PYqVAFpUIoOJdxQrxn19wlWTz6OhFNILPI59FUWRdZLs7Bz7W1xDLCjrCm461RuX
 /Ugw8dXC+Q1B5hj8rZ5lUyKzHSkceFBMT7rgnTmURn2gLOFsdOkU+Guyul7BGoI6WIxx
 gRgAT21cRoSVMm6TWoy4D6NC5Cr9RWPI+cHd5QB3mxdzfXaC6wjXI+ovXoeKp5MEcp/d oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3end6g43rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 17:10:37 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227GVUGU001674;
        Mon, 7 Mar 2022 17:10:37 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3end6g43qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 17:10:36 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227H35JE017003;
        Mon, 7 Mar 2022 17:10:34 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3ekyg94gt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 17:10:34 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227HAVrV43647318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 17:10:31 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 062564C040;
        Mon,  7 Mar 2022 17:10:31 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E58F4C044;
        Mon,  7 Mar 2022 17:10:30 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.73.209])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon,  7 Mar 2022 17:10:30 +0000 (GMT)
Date:   Mon, 7 Mar 2022 18:10:27 +0100
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
Message-ID: <20220307181027.29c821b6.pasic@linux.ibm.com>
In-Reply-To: <151241e6-3099-4be2-da54-1f0e5cb3a705@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
        <20220215005040.52697-9-akrowiak@linux.ibm.com>
        <97681738-50a1-976d-9f0f-be326eab7202@linux.ibm.com>
        <9ac3908e-06da-6276-d1df-94898918fc5b@linux.ibm.com>
        <20220307142711.5af33ece.pasic@linux.ibm.com>
        <151241e6-3099-4be2-da54-1f0e5cb3a705@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8ESeYzpXOab-qYbc1klVDE9pxrJgcCK7
X-Proofpoint-GUID: q3QEZXEdGxdwolAbq1CXYupZ3dbEbiBr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_08,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Mar 2022 09:10:29 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 3/7/22 08:27, Halil Pasic wrote:
> > On Mon, 7 Mar 2022 07:31:21 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> On 3/3/22 10:39, Jason J. Herne wrote:  
> >>> On 2/14/22 19:50, Tony Krowiak wrote:  
> >>>>    /**
> >>>> - * vfio_ap_mdev_verify_no_sharing - verifies that the AP matrix is
> >>>> not configured
> >>>> + * vfio_ap_mdev_verify_no_sharing - verify APQNs are not shared by
> >>>> matrix mdevs
> >>>>     *
> >>>> - * @matrix_mdev: the mediated matrix device
> >>>> + * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
> >>>> + * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
> >>>>     *
> >>>> - * Verifies that the APQNs derived from the cross product of the AP
> >>>> adapter IDs
> >>>> - * and AP queue indexes comprising the AP matrix are not configured
> >>>> for another
> >>>> + * Verifies that each APQN derived from the Cartesian product of a
> >>>> bitmap of
> >>>> + * AP adapter IDs and AP queue indexes is not configured for any matrix
> >>>>     * mediated device. AP queue sharing is not allowed.
> >>>>     *
> >>>> - * Return: 0 if the APQNs are not shared; otherwise returns
> >>>> -EADDRINUSE.
> >>>> + * Return: 0 if the APQNs are not shared; otherwise return -EADDRINUSE.
> >>>>     */
> >>>> -static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev
> >>>> *matrix_mdev)
> >>>> +static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
> >>>> +                      unsigned long *mdev_aqm)
> >>>>    {
> >>>> -    struct ap_matrix_mdev *lstdev;
> >>>> +    struct ap_matrix_mdev *matrix_mdev;
> >>>>        DECLARE_BITMAP(apm, AP_DEVICES);
> >>>>        DECLARE_BITMAP(aqm, AP_DOMAINS);
> >>>>    -    list_for_each_entry(lstdev, &matrix_dev->mdev_list, node) {
> >>>> -        if (matrix_mdev == lstdev)
> >>>> +    list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
> >>>> +        /*
> >>>> +         * If the input apm and aqm belong to the matrix_mdev's matrix,  
> > How about:
> >
> > s/belong to the matrix_mdev's matrix/are fields of the matrix_mdev
> > object/  
> 
> This is the comment I wrote:
> 
>          /*
>           * Comparing an mdev's newly updated apm/aqm with itself would
>           * result in a false positive when verifying whether any APQNs
>           * are shared; so, if the input apm and aqm belong to the
>           * matrix_mdev's matrix, then move on to the next one.
>           */
> 
> However, I'd be happy to change it to whatever either of you want.

What ain't obvious for the comment is that "belong to" actually means
composition and not association. In other words, there there is no
pointer/indirection involved, a pointer that would tell us what matrix
does belong to what matrix_mdev, but rather the matrix is just a part
of the matrix_mdev object.

I don't like 'false positive' either, and whether the apm/aqm is
newly updated or not is also redundant and confusing in my opinion. When
we check because of inuse there is not updated whatever. IMHO the old
message was better than this one.

Just my opinion, if you two agree, that this is the way to go, I'm fine
with that.

Regards,
Halil


