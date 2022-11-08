Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582CB621CE0
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 20:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiKHTSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 14:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiKHTSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 14:18:44 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BC9175A9;
        Tue,  8 Nov 2022 11:18:32 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A8JDR2Q024441;
        Tue, 8 Nov 2022 19:18:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=y8j7WZTnEnj/qW2WCDBnYQXSr6VTyWeRPWnO/pLHYy4=;
 b=arXGuHyGro1BNdkYe5U42aVMAurAnsLqmXhdGjhtKH3gyuN2eBxzGyPR6SDGUV0hV565
 rEYLkkGty8J6jGBdHbvzVl2f36qIcNyEVXcYR4EEWdmxfX681Tp6gX/aecOxQhpmI3AJ
 GuiW1deIh3vXKJnMFpgzSXFb0MZkUjlV/4YqOk4W/q5cudZTTNQDMrgMlkLliYpL+0BJ
 l7r9uXx7bYS9snIpBoDirKRzbUf9qoPkKkeVpZ12f9QAqpPdNdMII8u9FOmQ5A6Kq+hW
 Nl1ID6hpvwnD9kmWaF4OvU2igrsCDR8IiBO8IZScKtxddSdDmiUneUf8H4q8IqP1lOWM YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqw2ur43s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 19:18:16 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A8JEV7k027404;
        Tue, 8 Nov 2022 19:18:16 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqw2ur43h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 19:18:16 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A8J6O6c015955;
        Tue, 8 Nov 2022 19:18:15 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 3kngptrgda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 19:18:15 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A8JICXt11928284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Nov 2022 19:18:13 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F36A15806D;
        Tue,  8 Nov 2022 19:18:13 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADE2658065;
        Tue,  8 Nov 2022 19:18:12 +0000 (GMT)
Received: from [9.160.191.98] (unknown [9.160.191.98])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  8 Nov 2022 19:18:12 +0000 (GMT)
Message-ID: <f2f8b63c-ecc7-7413-7134-089d30ba8e7d@linux.ibm.com>
Date:   Tue, 8 Nov 2022 14:18:12 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: S390 testing for IOMMUFD
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
 <Y2msLjrbvG5XPeNm@nvidia.com>
 <c32829c8-1259-7441-f6df-04f44a39ab2f@linux.ibm.com>
 <Y2pffsdWwnfjrTbv@nvidia.com>
 <67dafaf27cc029ffde1f7c474c2fd17907958d5a.camel@linux.ibm.com>
 <Y2ppq9oeKZzk5F6h@nvidia.com>
 <ce7bfc8b7efccf0fc35f89d3c79992dfba511b3a.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <ce7bfc8b7efccf0fc35f89d3c79992dfba511b3a.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MvG2WmSAJR_0TMf1RIUdf8bSPHVow40K
X-Proofpoint-ORIG-GUID: 85j1czU6AYqD9zysLlrdvY7IS1gx9pYT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 impostorscore=0 phishscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211080121
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/8/22 10:29 AM, Eric Farman wrote:
> On Tue, 2022-11-08 at 10:37 -0400, Jason Gunthorpe wrote:
>> On Tue, Nov 08, 2022 at 09:19:17AM -0500, Eric Farman wrote:
>>> On Tue, 2022-11-08 at 09:54 -0400, Jason Gunthorpe wrote:
>>>> On Tue, Nov 08, 2022 at 08:50:53AM -0500, Matthew Rosato wrote:
>>>>
>>>>> FWIW, vfio-pci via s390 is working fine so far, though I'll put
>>>>> it
>>>>> through more paces over the next few weeks and report if I find
>>>>> anything.
>>>>
>>>> OK great
>>>>
>>>>> As far as mdev drivers...  
>>>>>
>>>>> -ccw: Sounds like Eric is already aware there is an issue and
>>>>> is
>>>>> investigating (I see errors as well).
>>>
>>> I -think- the problem for -ccw is that the new vfio_pin_pages
>>> requires
>>> the input addresses to be page-aligned, and while most of ours are,
>>> the
>>> first one in any given transaction may not be. We never bothered to
>>> mask off the addresses since it was handled for us, and we needed
>>> to
>>> keep the offsets anyway.
>>>
>>> By happenstance, I had some code that would do the masking
>>> ourselves
>>> (for an unrelated reason); I'll see if I can get that fit on top
>>> and if
>>> it helps matters. After coffee.
>>
>> Oh, yes, that makes alot of sense.
>>
>> Ah, if that is how VFIO worked we could match it like below:
> 
> That's a start. The pin appears to have worked, but the unpin fails at
> the bottom of iommufd_access_unpin_pages:
> 
> WARN_ON(!iopt_area_contig_done(&iter));
> 

Update on why -ap is failing -- I see vfio_pin_pages requests from vfio_ap_irq_enable that are failing on -EINVAL -- input is not page-aligned, just like what vfio-ccw was hitting.

I just tried a quick hack to force these to page-aligned requests and with that the vfio-ap tests I'm running start passing again.  So I think a proper fix in the iommufd code for this will also fix vfio-ap (we will test of course)

>>
>>  EXPORT_SYMBOL_NS_GPL(iommufd_access_unpin_pages, IOMMUFD);
>>  
>>  static bool iopt_area_contig_is_aligned(struct iopt_area_contig_iter
>> *iter,
>> -                                       bool first)
>> +                                       bool first, unsigned long
>> first_iova)
>>  {
>> -       if (iopt_area_start_byte(iter->area, iter->cur_iova) %
>> PAGE_SIZE)
>> +       unsigned long start_offset = first ? (first_iova % PAGE_SIZE)
>> : 0;
>> +
>> +       if ((iopt_area_start_byte(iter->area, iter->cur_iova) %
>> PAGE_SIZE) !=
>> +           start_offset)
>>                 return false;
>>  
>>         if (!iopt_area_contig_done(iter) &&
>> @@ -607,7 +610,7 @@ int iommufd_access_pin_pages(struct
>> iommufd_access *access, unsigned long iova,
>>                         iopt_area_iova_to_index(area, iter.cur_iova);
>>  
>>                 if (area->prevent_access ||
>> -                   !iopt_area_contig_is_aligned(&iter, first)) {
>> +                   !iopt_area_contig_is_aligned(&iter, first, iova))
>> {
>>                         rc = -EINVAL;
>>                         goto err_remove;
>>                 }
>>
>> Jason
> 

