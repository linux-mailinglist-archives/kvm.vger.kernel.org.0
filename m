Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFBF4CFE86
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 13:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242300AbiCGMc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 07:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242341AbiCGMcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 07:32:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5216285BF5;
        Mon,  7 Mar 2022 04:32:01 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227CKeLG010351;
        Mon, 7 Mar 2022 12:31:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5QDCvWRzyM1ZpoqqsIXfChJDJUzfAOecksfaNhe/CA4=;
 b=VytOMf9rIHW1EMWZb6RPhCzlseFGZSb23gSrgw/XcWo+7++6VbKXMukAt7hKU0KpqlXh
 /z6Pulz+YQZteFf1MIhB6k66kRynLKGWLpPHANBRHLOKEpxT5z1gCLgpY+Czv4vKXlEX
 cAhsFUqQeQTt4eY9gfHUbK7QuILhmJxij8vwN9OtcUdqU1k7DpjJFlK0PHuDJcMgs7yW
 7jPrrnhr4VdCWtcaz5c28T7m+aaq91JbSKT1y6SbD9PyVoRJ/OFHkqAGQaRPwPogDdgX
 QMzrrfhjpAzzB01xHizW59DNw6YV4xpQUhHXXElVr5+6OXBkeyntXvI539qVgdQmZ+Et ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enhymr76u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 12:31:58 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227CULIv014396;
        Mon, 7 Mar 2022 12:31:57 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enhymr76f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 12:31:57 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227CBijb013043;
        Mon, 7 Mar 2022 12:31:56 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 3ekyg8wmdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 12:31:56 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227CVtOf22544884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 12:31:55 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05CAA124062;
        Mon,  7 Mar 2022 12:31:55 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1D48124054;
        Mon,  7 Mar 2022 12:31:53 +0000 (GMT)
Received: from [9.160.116.147] (unknown [9.160.116.147])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  7 Mar 2022 12:31:53 +0000 (GMT)
Message-ID: <9ac3908e-06da-6276-d1df-94898918fc5b@linux.ibm.com>
Date:   Mon, 7 Mar 2022 07:31:21 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v18 08/18] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
Content-Language: en-US
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-9-akrowiak@linux.ibm.com>
 <97681738-50a1-976d-9f0f-be326eab7202@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <97681738-50a1-976d-9f0f-be326eab7202@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BsmAaZzMI6qGUcOWra1oRR8Eekeea3p5
X-Proofpoint-ORIG-GUID: iR41C7Q0-ISCWd3p_Hk2Vf6sFcc47eBm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_04,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 phishscore=0 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/3/22 10:39, Jason J. Herne wrote:
> On 2/14/22 19:50, Tony Krowiak wrote:
>>   /**
>> - * vfio_ap_mdev_verify_no_sharing - verifies that the AP matrix is 
>> not configured
>> + * vfio_ap_mdev_verify_no_sharing - verify APQNs are not shared by 
>> matrix mdevs
>>    *
>> - * @matrix_mdev: the mediated matrix device
>> + * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
>> + * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
>>    *
>> - * Verifies that the APQNs derived from the cross product of the AP 
>> adapter IDs
>> - * and AP queue indexes comprising the AP matrix are not configured 
>> for another
>> + * Verifies that each APQN derived from the Cartesian product of a 
>> bitmap of
>> + * AP adapter IDs and AP queue indexes is not configured for any matrix
>>    * mediated device. AP queue sharing is not allowed.
>>    *
>> - * Return: 0 if the APQNs are not shared; otherwise returns 
>> -EADDRINUSE.
>> + * Return: 0 if the APQNs are not shared; otherwise return -EADDRINUSE.
>>    */
>> -static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev 
>> *matrix_mdev)
>> +static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
>> +                      unsigned long *mdev_aqm)
>>   {
>> -    struct ap_matrix_mdev *lstdev;
>> +    struct ap_matrix_mdev *matrix_mdev;
>>       DECLARE_BITMAP(apm, AP_DEVICES);
>>       DECLARE_BITMAP(aqm, AP_DOMAINS);
>>   -    list_for_each_entry(lstdev, &matrix_dev->mdev_list, node) {
>> -        if (matrix_mdev == lstdev)
>> +    list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
>> +        /*
>> +         * If the input apm and aqm belong to the matrix_mdev's matrix,
>> +         * then move on to the next.
>> +         */
>> +        if (mdev_apm == matrix_mdev->matrix.apm &&
>> +            mdev_aqm == matrix_mdev->matrix.aqm)
>>               continue;
>
> We may have a problem here. This check seems like it exists to stop 
> you from
> comparing an mdev's apm/aqm with itself. Obviously comparing an mdev's 
> newly
> updated apm/aqm with itself would cause a false positive sharing 
> check, right?
> If this is the case, I think the comment should be changed to reflect 
> that.

You are correct, this check is performed to prevent comparing an mdev to
itself, I'll improve the comment.

>
> Aside from the comment, what stops this particular series of if 
> statements from
> allowing us to configure a second mdev with the exact same apm/aqm 
> values as an
> existing mdev? If we do, then this check's continue will short circuit 
> the rest
> of the function thereby allowing that 2nd mdev even though it should be a
> sharing violation.

I don't see how this is possible.

The function above is called from two places: the 
vfio_ap_mdev_validate_masks()
function which is invoked when an adapter or domain is assigned to the 
mdev; and the
vfio_ap_mdev_resource_in_use() function which is a callback registered 
with the
AP bus and is called by the bus when the apmask/aqmask are changed.

In the former case, the addresses passed in are from the apm/aqm fields 
within
the ap_matrix structure. Each ap_matrix structure is a field contained 
within an
ap_matrix_mdev structure, it is not a pointer to storage allocated 
external to
the matrix_mdev, so the apm/aqm addresses passed in from the
vfio_ap_mdev_validate_masks() function will be unique to each 
ap_matrix_mdev
structure.

In the latter case, the addresses are passed in by the AP bus and are 
allocated by the
bus and would definitely not be contained within an ap_matrix_mdev since 
the AP bus
doesn't even have access to that structure.

>
>

