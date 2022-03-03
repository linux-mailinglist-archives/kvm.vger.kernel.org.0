Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152004CC1A9
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 16:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbiCCPkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 10:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiCCPku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 10:40:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9862D195313;
        Thu,  3 Mar 2022 07:40:04 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223DXjUG016756;
        Thu, 3 Mar 2022 15:40:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=7MaOOpnZQEaMhi0BzwCt3BeviEZg6vV7D0hFaJSE9K8=;
 b=gj988ogzbAU3NxpQm+sRQW+WSVzzV4Qj2pF+RAckX0WAjHYAzk0fZ8ov0o3/yAVp0NFl
 LiJ+S7DfZ4H6mGZdJmG0YmK5fjSOJeTfgurFhYFPHcVeMON3uT0G3A1E/co1FCnVFIK+
 nHsugf4jvYJsoKSgTGFngGqgW5c2l/lmT5cmFl3EzkBlX+11vNUsj3n+kf5BdXps7iBq
 oh4WY6VT7bbUUDjmRzM/+SxA6rlVsjN2tgA1Kizrvk8nhTXCBfIHA1q0JB2jT9rKUdQQ
 vzE24dLRa1ufahkRb3YDJ4gMad7d6QEgY8BuTS36kIE7PWgaAucoM5PwVN1ERvUBbBNz 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejvbbwxmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 15:40:02 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 223Fcj9D008757;
        Thu, 3 Mar 2022 15:40:02 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejvbbwxmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 15:40:02 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 223FcdP8001032;
        Thu, 3 Mar 2022 15:40:01 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 3efbuah7wy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 15:40:01 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 223Fdxug15860010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Mar 2022 15:39:59 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0EBC136059;
        Thu,  3 Mar 2022 15:39:59 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84FBB13604F;
        Thu,  3 Mar 2022 15:39:58 +0000 (GMT)
Received: from [9.160.181.120] (unknown [9.160.181.120])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  3 Mar 2022 15:39:58 +0000 (GMT)
Message-ID: <97681738-50a1-976d-9f0f-be326eab7202@linux.ibm.com>
Date:   Thu, 3 Mar 2022 10:39:58 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v18 08/18] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-9-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220215005040.52697-9-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: J5vuu5TCFkzHfujRo4s6-Lf7CLdK5UDM
X-Proofpoint-ORIG-GUID: _UFSj0DwNP2H2JU_hmLEnh9wBbzgjhIT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_07,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 priorityscore=1501 mlxscore=0 adultscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203030074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/22 19:50, Tony Krowiak wrote:
>   /**
> - * vfio_ap_mdev_verify_no_sharing - verifies that the AP matrix is not configured
> + * vfio_ap_mdev_verify_no_sharing - verify APQNs are not shared by matrix mdevs
>    *
> - * @matrix_mdev: the mediated matrix device
> + * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
> + * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
>    *
> - * Verifies that the APQNs derived from the cross product of the AP adapter IDs
> - * and AP queue indexes comprising the AP matrix are not configured for another
> + * Verifies that each APQN derived from the Cartesian product of a bitmap of
> + * AP adapter IDs and AP queue indexes is not configured for any matrix
>    * mediated device. AP queue sharing is not allowed.
>    *
> - * Return: 0 if the APQNs are not shared; otherwise returns -EADDRINUSE.
> + * Return: 0 if the APQNs are not shared; otherwise return -EADDRINUSE.
>    */
> -static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
> +static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
> +					  unsigned long *mdev_aqm)
>   {
> -	struct ap_matrix_mdev *lstdev;
> +	struct ap_matrix_mdev *matrix_mdev;
>   	DECLARE_BITMAP(apm, AP_DEVICES);
>   	DECLARE_BITMAP(aqm, AP_DOMAINS);
>   
> -	list_for_each_entry(lstdev, &matrix_dev->mdev_list, node) {
> -		if (matrix_mdev == lstdev)
> +	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
> +		/*
> +		 * If the input apm and aqm belong to the matrix_mdev's matrix,
> +		 * then move on to the next.
> +		 */
> +		if (mdev_apm == matrix_mdev->matrix.apm &&
> +		    mdev_aqm == matrix_mdev->matrix.aqm)
>   			continue;

We may have a problem here. This check seems like it exists to stop you from
comparing an mdev's apm/aqm with itself. Obviously comparing an mdev's newly
updated apm/aqm with itself would cause a false positive sharing check, right?
If this is the case, I think the comment should be changed to reflect that.

Aside from the comment, what stops this particular series of if statements from
allowing us to configure a second mdev with the exact same apm/aqm values as an
existing mdev? If we do, then this check's continue will short circuit the rest
of the function thereby allowing that 2nd mdev even though it should be a
sharing violation.


-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
