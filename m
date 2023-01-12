Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA435667D38
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 19:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239958AbjALSB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 13:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbjALSAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 13:00:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D2D2DF;
        Thu, 12 Jan 2023 09:21:33 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30CGc4pQ004029;
        Thu, 12 Jan 2023 17:21:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gfW87/uYI6us7+NGhazZyPMGA5ouuXyjorEjax+ui4A=;
 b=az011qUTBMf27qV/NadZkidpcv8mfRalizOsHE4vdM3HBGs6vlhIMOtFdN0imzR37eF1
 St0NPIzMZ0GgEoNj12DQfTsRo+fQd6B4yRB2/jpB7grmLP1o17NdsZgjn8HYSe1uye44
 DHeAk0xqWWcDfWUrIY6LwkmOk2IkWKycqyo61j/Ht5Rkj9elATMbndbkoXd0rv7CzDAq
 ZTX7AiSMb6XNeBP/v+ndJaAHMIjaG73v5eGt43Ya+iX87co0GbDWbcHlTTmbnRrJgYfp
 +EKWMJEmypvAKtOOoXU0LKnMTQZBOvf09RgKDEEmFBtN9dsHz9KUXFkcDCWF9nEncfPU MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2n7ja603-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 17:21:28 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30CGdNha006968;
        Thu, 12 Jan 2023 17:21:27 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2n7ja5xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 17:21:27 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30CESXV0018910;
        Thu, 12 Jan 2023 17:21:24 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3n1knv2g8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 17:21:24 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30CHLNDC30802406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 17:21:23 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 923E658056;
        Thu, 12 Jan 2023 17:21:20 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5A1258054;
        Thu, 12 Jan 2023 17:21:17 +0000 (GMT)
Received: from [9.160.94.233] (unknown [9.160.94.233])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 12 Jan 2023 17:21:17 +0000 (GMT)
Message-ID: <f7c39317-92a4-520e-8e69-a8606cd40e9a@linux.ibm.com>
Date:   Thu, 12 Jan 2023 12:21:17 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/2] KVM: async kvm_destroy_vm for vfio devices
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     alex.williamson@redhat.com, pbonzini@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20230109201037.33051-1-mjrosato@linux.ibm.com>
 <20230109201037.33051-2-mjrosato@linux.ibm.com> <Y78UCz5oeuntSQtK@google.com>
 <Y78Wk2/P5+gLMdpk@nvidia.com> <Y78hzsHiwaFpL60+@google.com>
 <Y8AA8r5MzKQIF8I7@nvidia.com>
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <Y8AA8r5MzKQIF8I7@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: D5QRdGewSwIIbZrg8weuonUZQlbVEvfJ
X-Proofpoint-ORIG-GUID: O6lWfjrcKzZuxoIawFlmJvS5sh-bb7-X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_08,2023-01-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301120124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/12/23 7:45 AM, Jason Gunthorpe wrote:
> On Wed, Jan 11, 2023 at 08:53:34PM +0000, Sean Christopherson wrote:
>> On Wed, Jan 11, 2023, Jason Gunthorpe wrote:
>>> On Wed, Jan 11, 2023 at 07:54:51PM +0000, Sean Christopherson wrote:
>>>
>>>> Something feels off.  If KVM's refcount is 0, then accessing device->group->kvm
>>>> in vfio_device_open() can't happen unless there's a refcounting bug somewhere.
>>>
>>> The problem is in close, not open.
>>
>> The deadlock problem is, yes.  My point is that if group_lock needs to be taken
>> when nullifying group->kvm during kvm_vfio_destroy(), then there is also a refcounting
>> prolem with respect to open().  If there is no refcounting problem, then nullifying
>> group->kvm during kvm_vfio_destroy() is unnecessary (but again, I doubt this is
>> the case).
> 
> IIRC the drivers are supposed to use one of the refcount not zero
> incrs to counteract this, but I never checked they do..
> 
> Yi is working on a patch to change things so vfio drops the kvm
> pointer when the kvm file closes, not when the reference goes to 0
> to avoid a refcount cycle problem which should also solve that.
> 
>> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>> index 6e8804fe0095..b3a84d65baa6 100644
>> --- a/drivers/vfio/vfio_main.c
>> +++ b/drivers/vfio/vfio_main.c
>> @@ -772,7 +772,12 @@ static struct file *vfio_device_open(struct vfio_device *device)
>>  		 * reference and release it during close_device.
>>  		 */
>>  		mutex_lock(&device->group->group_lock);
>> -		device->kvm = device->group->kvm;
>> +
>> +		if (device->kvm_ops && device->group->kvm) {
>> +			ret = device->kvm_ops->get_kvm(device->group->kvm);
> 
> At this point I'd rather just use the symbol get stuff like kvm does
> and call the proper functions.
> 

So should I work up a v2 that does symbol gets for kvm_get_kvm_safe and kvm_put_kvm from vfio_main and drop kvm_put_kvm_async?  Or is the patch Yi is working on changing things such that will also address the deadlock issue?
 
If so, something like the following (where vfio_kvm_get symbol gets kvm_get_kvm_safe and vfio_kvm_put symbol gets kvm_put_kvm):

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 5177bb061b17..a49bf1080f0a 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -361,16 +361,22 @@ static int vfio_device_first_open(struct vfio_device *device,
        if (ret)
                goto err_module_put;
 
+       if (kvm && !vfio_kvm_get(kvm)) {
+               ret = -ENOENT;
+               goto err_unuse_iommu;
+       }
        device->kvm = kvm;
        if (device->ops->open_device) {
                ret = device->ops->open_device(device);
                if (ret)
-                       goto err_unuse_iommu;
+                       goto err_put_kvm;
        }
        return 0;
 
-err_unuse_iommu:
+err_put_kvm:
+       vfio_put_kvm(kvm);
        device->kvm = NULL;
+err_unuse_iommu:
        if (iommufd)
                vfio_iommufd_unbind(device);
        else
@@ -465,6 +471,9 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 
        vfio_device_group_close(device);
 
+       if (device->open_count == 0 && device->group->kvm)
+               vfio_kvm_put(device->group->kvm);
+
        vfio_device_put_registration(device);
 
        return 0;



