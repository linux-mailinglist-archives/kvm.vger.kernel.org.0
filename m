Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCC65F4820
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 19:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiJDRQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 13:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiJDRQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 13:16:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BCF24BCF;
        Tue,  4 Oct 2022 10:16:06 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 294Ff9pq032296;
        Tue, 4 Oct 2022 17:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eyLOLdtglKinuOC3hUyHKn1P8dBIYjzpdlRkV0aZ634=;
 b=crzqZhOVPJsKuXvBzcTaAyYmO7uw9eqEQTD7fB8PDsGaRzLj15rINJHJo1oG4btyqUUH
 Fs35nDTFZPMirZp1naTSug/t4UDSzbCfq8z+ybzh4OcYa80plY3y6Ovs+Q/6UUWsDVYj
 hcOjRJ+YKk1POkUcL10OIMv7ozDYwywy+pBUvCASIZThamz+iGa4SjVlu1YQr8u3svTS
 JmnvB9T+4L2pcvDmxP+x3Is9yCfJABN3EVGY5vwaeZHnZHGf59VuZJM7RpKrTXsyMkQ3
 r7D3Qa9zY5HnlZWsdPHyKmfhBXxcobGT/6miJpXZYDLyAGsIRBymmJR1eVUQOcDrYrSI yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0gu2qrmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 17:15:58 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 294GjEL9004331;
        Tue, 4 Oct 2022 17:15:58 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0gu2qrm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 17:15:57 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 294H67r8013309;
        Tue, 4 Oct 2022 17:15:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3jxd694g48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 17:15:55 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 294HGMWh49152320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Oct 2022 17:16:22 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2F2652050;
        Tue,  4 Oct 2022 17:15:52 +0000 (GMT)
Received: from [9.171.7.248] (unknown [9.171.7.248])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2FC6A5204E;
        Tue,  4 Oct 2022 17:15:52 +0000 (GMT)
Message-ID: <b11044c1-af26-4442-25a6-655a9872e956@linux.ibm.com>
Date:   Tue, 4 Oct 2022 19:15:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
 <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
 <20220927140541.6f727b01.alex.williamson@redhat.com>
 <52545d8b-956b-8934-8a7e-212729ea2855@linux.ibm.com>
 <YzxT6Suu+272gDvP@nvidia.com>
 <1aebfa84-8310-5dff-1862-3d143878d9dd@linux.ibm.com>
 <YzxfK/e14Bx9yNyo@nvidia.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <YzxfK/e14Bx9yNyo@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: B9X50V8pf7oUnpT32xs6rMyzxz00oK_o
X-Proofpoint-GUID: XflaMLkUr2KoPnl3W6rGUE4Rgz_WuDfI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_08,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 adultscore=0 priorityscore=1501 suspectscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210040111
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Am 04.10.22 um 18:28 schrieb Jason Gunthorpe:
> On Tue, Oct 04, 2022 at 05:44:53PM +0200, Christian Borntraeger wrote:
> 
>>> Does some userspace have the group FD open when it stucks like this,
>>> eg what does fuser say?
>>
>> /proc/<virtnodedevd>/fd
>> 51480 0 dr-x------. 2 root root  0  4. Okt 17:16 .
>> 43593 0 dr-xr-xr-x. 9 root root  0  4. Okt 17:16 ..
>> 65252 0 lr-x------. 1 root root 64  4. Okt 17:42 0 -> /dev/null
>> 65253 0 lrwx------. 1 root root 64  4. Okt 17:42 1 -> 'socket:[51479]'
>> 65261 0 lrwx------. 1 root root 64  4. Okt 17:42 10 -> 'anon_inode:[eventfd]'
>> 65262 0 lrwx------. 1 root root 64  4. Okt 17:42 11 -> 'socket:[51485]'
>> 65263 0 lrwx------. 1 root root 64  4. Okt 17:42 12 -> 'socket:[51487]'
>> 65264 0 lrwx------. 1 root root 64  4. Okt 17:42 13 -> 'socket:[51486]'
>> 65265 0 lrwx------. 1 root root 64  4. Okt 17:42 14 -> 'anon_inode:[eventfd]'
>> 65266 0 lrwx------. 1 root root 64  4. Okt 17:42 15 -> 'socket:[60421]'
>> 65267 0 lrwx------. 1 root root 64  4. Okt 17:42 16 -> 'anon_inode:[eventfd]'
>> 65268 0 lrwx------. 1 root root 64  4. Okt 17:42 17 -> 'socket:[28008]'
>> 65269 0 l-wx------. 1 root root 64  4. Okt 17:42 18 -> /run/libvirt/nodedev/driver.pid
>> 65270 0 lrwx------. 1 root root 64  4. Okt 17:42 19 -> 'socket:[28818]'
>> 65254 0 lrwx------. 1 root root 64  4. Okt 17:42 2 -> 'socket:[51479]'
>> 65271 0 lr-x------. 1 root root 64  4. Okt 17:42 20 -> '/dev/vfio/3 (deleted)'
> 
> Seems like a userspace bug to keep the group FD open after the /dev/
> file has been deleted :|
> 
> What do you think about this?

On top of which tree is this?

> 
> commit a54a852b1484b1605917a8f4d80691db333b25ed
> Author: Jason Gunthorpe <jgg@ziepe.ca>
> Date:   Tue Oct 4 13:14:37 2022 -0300
> 
>      vfio: Make the group FD disassociate from the iommu_group
>      
>      Allow the vfio_group struct to exist with a NULL iommu_group pointer. When
>      the pointer is NULL the vfio_group users promise not to touch the
>      iommu_group. This allows a driver to be hot unplugged while userspace is
>      keeping the group FD open.
>      
>      SPAPR mode is excluded from this behavior because of how it wrongly hacks
>      part of its iommu interface through KVM. Due to this we loose control over
>      what it is doing and cannot revoke the iommu_group usage in the IOMMU
>      layer via vfio_group_detach_container().
>      
>      Thus, for SPAPR the group FDs must still be closed before a device can be
>      hot unplugged.
>      
>      This fixes a userspace regression where we learned that virtnodedevd
>      leaves a group FD open even though the /dev/ node for it has been deleted
>      and all the drivers for it unplugged.
>      
>      Fixes: ca5f21b25749 ("vfio: Follow a strict lifetime for struct iommu_group")
>      Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>      Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 59a28251bb0b97..badc9d828cac20 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1313,7 +1313,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>   		}
>   
>   		/* Ensure the FD is a vfio group FD.*/
> -		if (!vfio_file_iommu_group(file)) {
> +		if (!vfio_file_is_group(file)) {
>   			fput(file);
>   			ret = -EINVAL;
>   			break;
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 4d2de02f2ced6e..4e10a281420e66 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -59,6 +59,7 @@ struct vfio_group {
>   	struct mutex			group_lock;
>   	struct kvm			*kvm;
>   	struct file			*opened_file;
> +	bool				preserve_iommu_group;
>   	struct swait_queue_head		opened_file_wait;
>   	struct blocking_notifier_head	notifier;
>   };
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 9b1e5fd5f7b73c..e725cf38886c09 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -133,6 +133,10 @@ __vfio_group_get_from_iommu(struct iommu_group *iommu_group)
>   {
>   	struct vfio_group *group;
>   
> +	/*
> +	 * group->iommu_group from the vfio.group_list cannot be NULL
> +	 * under the vfio.group_lock.
> +	 */
>   	list_for_each_entry(group, &vfio.group_list, vfio_next) {
>   		if (group->iommu_group == iommu_group) {
>   			refcount_inc(&group->drivers);
> @@ -159,7 +163,7 @@ static void vfio_group_release(struct device *dev)
>   
>   	mutex_destroy(&group->device_lock);
>   	mutex_destroy(&group->group_lock);
> -	iommu_group_put(group->iommu_group);
> +	WARN_ON(group->iommu_group);
>   	ida_free(&vfio.group_ida, MINOR(group->dev.devt));
>   	kfree(group);
>   }
> @@ -248,6 +252,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
>   static void vfio_device_remove_group(struct vfio_device *device)
>   {
>   	struct vfio_group *group = device->group;
> +	struct iommu_group *iommu_group;
>   
>   	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
>   		iommu_group_remove_device(device->dev);
> @@ -266,12 +271,25 @@ static void vfio_device_remove_group(struct vfio_device *device)
>   	cdev_device_del(&group->cdev, &group->dev);
>   
>   	/*
> -	 * Before we allow the last driver in the group to be unplugged the
> -	 * group must be sanitized so nothing else is or can reference it. This
> -	 * is because the group->iommu_group pointer should only be used so long
> -	 * as a device driver is attached to a device in the group.
> +	 * Revoke all users of group->iommu_group. At this point we know there
> +	 * are no devices active because we are unplugging the last one. Setting
> +	 * iommu_group to NULL blocks all new users.
>   	 */
> -	while (group->opened_file) {
> +	WARN_ON(group->notifier.head);
> +	if (group->container)
> +		vfio_group_detach_container(group);
> +	iommu_group = group->iommu_group;
> +	group->iommu_group = NULL;
> +
> +	/*
> +	 * Normally we can set the iommu_group to NULL above and that will
> +	 * prevent any users from touching it. However, the SPAPR kvm path takes
> +	 * a reference to the iommu_group and keeps using it in arch code out
> +	 * side our control. So if this path is triggred we have no choice but
> +	 * to wait for the group FD to be closed to be sure everyone has stopped
> +	 * touching the group.
> +	 */
> +	while (group->preserve_iommu_group && group->opened_file) {
>   		mutex_unlock(&vfio.group_lock);
>   		swait_event_idle_exclusive(group->opened_file_wait,
>   					   !group->opened_file);
> @@ -288,8 +306,8 @@ static void vfio_device_remove_group(struct vfio_device *device)
>   	WARN_ON(!list_empty(&group->device_list));
>   	WARN_ON(group->container || group->container_users);
>   	WARN_ON(group->notifier.head);
> -	group->iommu_group = NULL;
>   
> +	iommu_group_put(iommu_group);
>   	put_device(&group->dev);
>   }
>   
> @@ -531,6 +549,10 @@ static int __vfio_register_dev(struct vfio_device *device,
>   
>   	existing_device = vfio_group_get_device(group, device->dev);
>   	if (existing_device) {
> +		/*
> +		 * group->iommu_group is non-NULL because we hold the drivers
> +		 * refcount.
> +		 */
>   		dev_WARN(device->dev, "Device already exists on group %d\n",
>   			 iommu_group_id(group->iommu_group));
>   		vfio_device_put_registration(existing_device);
> @@ -702,6 +724,11 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
>   		ret = -EINVAL;
>   		goto out_unlock;
>   	}
> +	if (!group->iommu_group) {
> +		ret = -ENODEV;
> +		goto out_unlock;
> +	}
> +
>   	container = vfio_container_from_file(f.file);
>   	ret = -EINVAL;
>   	if (container) {
> @@ -862,6 +889,11 @@ static int vfio_group_ioctl_get_status(struct vfio_group *group,
>   	status.flags = 0;
>   
>   	mutex_lock(&group->group_lock);
> +	if (!group->iommu_group) {
> +		mutex_unlock(&group->group_lock);
> +		return -ENODEV;
> +	}
> +
>   	if (group->container)
>   		status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET |
>   				VFIO_GROUP_FLAGS_VIABLE;
> @@ -938,13 +970,6 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
>   	filep->private_data = NULL;
>   
>   	mutex_lock(&group->group_lock);
> -	/*
> -	 * Device FDs hold a group file reference, therefore the group release
> -	 * is only called when there are no open devices.
> -	 */
> -	WARN_ON(group->notifier.head);
> -	if (group->container)
> -		vfio_group_detach_container(group);
>   	group->opened_file = NULL;
>   	mutex_unlock(&group->group_lock);
>   	swake_up_one(&group->opened_file_wait);
> @@ -1553,17 +1578,34 @@ static const struct file_operations vfio_device_fops = {
>    * @file: VFIO group file
>    *
>    * The returned iommu_group is valid as long as a ref is held on the file.
> + * This function is deprecated, only the SPAPR path in kvm should call it.
>    */
>   struct iommu_group *vfio_file_iommu_group(struct file *file)
>   {
>   	struct vfio_group *group = file->private_data;
> +	struct iommu_group *iommu_group = NULL;
> +
> +	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
> +		return NULL;
>   
>   	if (file->f_op != &vfio_group_fops)
>   		return NULL;
> -	return group->iommu_group;
> +
> +	mutex_lock(&group->group_lock);
> +	if (group->iommu_group) {
> +		iommu_group = group->iommu_group;
> +		group->preserve_iommu_group = true;
> +	}
> +	mutex_unlock(&group->group_lock);
> +	return iommu_group;
>   }
>   EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
>   
> +bool vfio_file_is_group(struct file *file)
> +{
> +	return (file->f_op == &vfio_group_fops;
> +}
> +
>   /**
>    * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
>    *        is always CPU cache coherent
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 73bcb92179a224..bd9faaab85de18 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -199,6 +199,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
>    * External user API
>    */
>   struct iommu_group *vfio_file_iommu_group(struct file *file);
> +bool vfio_file_is_group(struct file *file);
>   bool vfio_file_enforced_coherent(struct file *file);
>   void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
>   bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index ce1b01d02c5197..6ecd3aca047375 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -77,6 +77,23 @@ static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
>   	return ret;
>   }
>   
> +static bool kvm_vfio_file_is_group(struct file *file)
> +{
> +	bool (*fn)(struct file *file);
> +	bool ret;
> +
> +	fn = symbol_get(vfio_file_is_group);
> +	if (!fn)
> +		return false;
> +
> +	ret = fn(file);
> +
> +	symbol_put(vfio_file_is_group);
> +
> +	return ret;
> +}
> +
> +
>   #ifdef CONFIG_SPAPR_TCE_IOMMU
>   static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
>   					     struct kvm_vfio_group *kvg)
> @@ -136,7 +153,7 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
>   		return -EBADF;
>   
>   	/* Ensure the FD is a vfio group FD.*/
> -	if (!kvm_vfio_file_iommu_group(filp)) {
> +	if (!kvm_vfio_file_is_group(filp)) {
>   		ret = -EINVAL;
>   		goto err_fput;
>   	}
