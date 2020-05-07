Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337631C81D4
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 07:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgEGFtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 01:49:55 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14753 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgEGFtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 01:49:55 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eb3a1000000>; Wed, 06 May 2020 22:47:44 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 06 May 2020 22:49:54 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 06 May 2020 22:49:54 -0700
Received: from [10.40.101.152] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 May
 2020 05:49:45 +0000
Subject: Re: [PATCH v1 2/2] Sample mtty: Add migration capability to mtty
 module
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1588614860-16330-1-git-send-email-kwankhede@nvidia.com>
 <1588614860-16330-3-git-send-email-kwankhede@nvidia.com>
 <20200507010126.GD19334@joy-OptiPlex-7040>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <a26d1031-3630-2e7f-e8df-e9a5db07397c@nvidia.com>
Date:   Thu, 7 May 2020 11:19:40 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200507010126.GD19334@joy-OptiPlex-7040>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588830464; bh=QMrHD8NsSkdPVanYHQ5XrGVopuTeHjei30hFL2q43ls=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=O0sBPXO/O++83pr519B4xRCCws55IVfUCYCzJsHFJTvNjEm/8IhG2g6IwKirHhHUs
         9Z4PHzEl64OKyN+1SsQd/DiV5TJZM4XpoTcVqGMZa0GIEbF9xNgONxyQ9S+cQDQ4M6
         5sMhZFrHLR2UjXS/YiSPoORXG9VWf0rKf8LxKN+8qqXfzGoz2+TJSMU62+dwcsIgAC
         XcTi5R22oomwU0SSMwtYsXnOpEb3UoC3d93M2NEq5X+exCPDemZ6hYK+bQoe1sDIHQ
         xLK/NfwNIYO/ku8OHJ6k57LKP7LcUceGyFdJ26N2L4oTsKL2PjLjA3bD5m9oB1Bq4B
         TGl4R4e2PhB+A==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/7/2020 6:31 AM, Yan Zhao wrote:
> On Tue, May 05, 2020 at 01:54:20AM +0800, Kirti Wankhede wrote:
>> This patch makes mtty device migration capable. Purpose od this code is
>> to test migration interface. Only stop-and-copy phase is implemented.
>> Postcopy migration is not supported.
>>
>> Actual data for mtty device migration is very less. Appended dummy data to
>> migration data stream, default 100 Mbytes. Added sysfs file
>> 'dummy_data_size_MB' to get dummy data size from user which can be used
>> to check performance of based of data size. During resuming dummy data is
>> read and discarded.
>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> ---
>>   samples/vfio-mdev/mtty.c | 602 ++++++++++++++++++++++++++++++++++++++++++++---
>>   1 file changed, 574 insertions(+), 28 deletions(-)
>>
>> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
>> index bf666cce5bb7..f9194234fc6a 100644
>> --- a/samples/vfio-mdev/mtty.c
>> +++ b/samples/vfio-mdev/mtty.c
>> @@ -44,9 +44,23 @@
>>   
>>   #define MTTY_STRING_LEN		16
>>   
>> -#define MTTY_CONFIG_SPACE_SIZE  0xff
>> -#define MTTY_IO_BAR_SIZE        0x8
>> -#define MTTY_MMIO_BAR_SIZE      0x100000
>> +#define MTTY_CONFIG_SPACE_SIZE		0xff
>> +#define MTTY_IO_BAR_SIZE		0x8
>> +#define MTTY_MMIO_BAR_SIZE		0x100000
>> +#define MTTY_MIGRATION_REGION_SIZE	0x1000000	// 16M
>> +
>> +#define MTTY_MIGRATION_REGION_INDEX	VFIO_PCI_NUM_REGIONS
>> +#define MTTY_REGIONS_MAX		(MTTY_MIGRATION_REGION_INDEX + 1)
>> +
>> +/* Data section start from page aligned offset */
>> +#define MTTY_MIGRATION_REGION_DATA_OFFSET	(0x1000)
>> +
>> +/* First page is used for struct vfio_device_migration_info */
>> +#define MTTY_MIGRATION_REGION_SIZE_MMAP     \
>> +	(MTTY_MIGRATION_REGION_SIZE - MTTY_MIGRATION_REGION_DATA_OFFSET)
>> +
>> +#define MIGRATION_INFO_OFFSET(MEMBER)	\
>> +		offsetof(struct vfio_device_migration_info, MEMBER)
>>   
>>   #define STORE_LE16(addr, val)   (*(u16 *)addr = val)
>>   #define STORE_LE32(addr, val)   (*(u32 *)addr = val)
>> @@ -129,6 +143,28 @@ struct serial_port {
>>   	u8 intr_trigger_level;  /* interrupt trigger level */
>>   };
>>   
>> +/* Migration packet */
>> +#define PACKET_ID		(u16)(0xfeedbaba)
>> +
>> +#define PACKET_FLAGS_ACTUAL_DATA	(1 << 0)
>> +#define PACKET_FLAGS_DUMMY_DATA		(1 << 1)
>> +
>> +#define PACKET_DATA_SIZE_MAX		(8 * 1024 * 1024)
>> +
>> +struct packet {
>> +	u16 id;
>> +	u16 flags;
>> +	u32 data_size;
>> +	u8 data[];
>> +};
>> +
>> +enum {
>> +	PACKET_STATE_NONE = 0,
>> +	PACKET_STATE_PREPARED,
>> +	PACKET_STATE_COPIED,
>> +	PACKET_STATE_LAST,
>> +};
>> +
>>   /* State of each mdev device */
>>   struct mdev_state {
>>   	int irq_fd;
>> @@ -138,22 +174,37 @@ struct mdev_state {
>>   	u8 *vconfig;
>>   	struct mutex ops_lock;
>>   	struct mdev_device *mdev;
>> -	struct mdev_region_info region_info[VFIO_PCI_NUM_REGIONS];
>> -	u32 bar_mask[VFIO_PCI_NUM_REGIONS];
>> +	struct mdev_region_info region_info[MTTY_REGIONS_MAX];
>> +	u32 bar_mask[MTTY_REGIONS_MAX];
>>   	struct list_head next;
>>   	struct serial_port s[2];
>>   	struct mutex rxtx_lock;
>>   	struct vfio_device_info dev_info;
>> -	int nr_ports;
>> +	u32 nr_ports;
>>   
>>   	/* List of pinned gpfns, gpfn as index and content is translated hpfn */
>>   	unsigned long *gpfn_to_hpfn;
>>   	struct notifier_block nb;
>> +
>> +	u32 device_state;
>> +	u64 saved_size;
>> +	void *mig_region_base;
>> +	bool is_actual_data_sent;
>> +	struct packet *pkt;
>> +	u32 packet_state;
>> +	u64 dummy_data_size;
>>   };
>>   
>>   static struct mutex mdev_list_lock;
>>   static struct list_head mdev_devices_list;
>>   
>> +/*
>> + * Default dummy data size set to 100 MB. To change value of dummy data size at
>> + * runtime but before migration write size in MB to sysfs file
>> + * dummy_data_size_MB
>> + */
>> +static unsigned long user_dummy_data_size = (100 * 1024 * 1024);
>> +
>>   static const struct file_operations vd_fops = {
>>   	.owner          = THIS_MODULE,
>>   };
>> @@ -639,6 +690,288 @@ static void mdev_read_base(struct mdev_state *mdev_state)
>>   	}
>>   }
>>   
>> +static int save_setup(struct mdev_state *mdev_state)
>> +{
>> +	mdev_state->is_actual_data_sent = false;
>> +
>> +	memset(mdev_state->pkt, 0, sizeof(struct packet) +
>> +				   PACKET_DATA_SIZE_MAX);
>> +
>> +	return 0;
>> +}
>> +
>> +static int set_device_state(struct mdev_state *mdev_state, u32 device_state)
>> +{
>> +	int ret = 0;
>> +
>> +	if (mdev_state->device_state == device_state)
>> +		return 0;
>> +
>> +	if (device_state & VFIO_DEVICE_STATE_RUNNING) {
>> +#if defined(DEBUG)
>> +		if (device_state & VFIO_DEVICE_STATE_SAVING) {
>> +			pr_info("%s: %s Pre-copy\n", __func__,
>> +				dev_name(mdev_dev(mdev_state->mdev)));
>> +		} else
>> +			pr_info("%s: %s Running\n", __func__,
>> +				dev_name(mdev_dev(mdev_state->mdev)));
>> +#endif
>> +	} else {
>> +		if (device_state & VFIO_DEVICE_STATE_SAVING) {
>> +#if defined(DEBUG)
>> +			pr_info("%s: %s Stop-n-copy\n", __func__,
>> +				dev_name(mdev_dev(mdev_state->mdev)));
>> +#endif
>> +			ret = save_setup(mdev_state);
>> +
>> +		} else if (device_state & VFIO_DEVICE_STATE_RESUMING) {
>> +#if defined(DEBUG)
>> +			pr_info("%s: %s Resuming\n", __func__,
>> +				dev_name(mdev_dev(mdev_state->mdev)));
>> +		} else {
>> +			pr_info("%s: %s Stopped\n", __func__,
>> +				dev_name(mdev_dev(mdev_state->mdev)));
>> +#endif
>> +		}
>> +	}
>> +
>> +	mdev_state->device_state = device_state;
>> +
>> +	return ret;
>> +}
>> +
>> +static u32 get_device_state(struct mdev_state *mdev_state)
>> +{
>> +	return mdev_state->device_state;
>> +}
>> +
>> +static void write_to_packet(struct packet *pkt, u8 *data, size_t size)
>> +{
>> +	if ((pkt->data_size + size) > PACKET_DATA_SIZE_MAX) {
>> +		pr_err("%s: packet data overflow\n", __func__);
>> +		return;
>> +	}
>> +	memcpy((void *)&pkt->data[pkt->data_size], (void *)data, size);
>> +	pkt->data_size += size;
>> +}
>> +
>> +static void read_from_packet(struct packet *pkt, u8 *data,
>> +			     int index, size_t size)
>> +{
>> +	if ((index + size) > PACKET_DATA_SIZE_MAX) {
>> +		pr_err("%s: packet data overflow\n", __func__);
>> +		return;
>> +	}
>> +
>> +	memcpy((void *)data, (void *)&pkt->data[index], size);
>> +}
>> +
>> +static int save_device_data(struct mdev_state *mdev_state, u64 *pending)
>> +{
>> +	/* Save device data only during stop-and-copy phase */
>> +	if (mdev_state->device_state != VFIO_DEVICE_STATE_SAVING) {
>> +		*pending = 0;
>> +		return 0;
>> +	}
>> +
>> +	if (mdev_state->packet_state == PACKET_STATE_PREPARED) {
>> +		*pending = sizeof(struct packet) + mdev_state->pkt->data_size;
>> +		return 0;
>> +	}
>> +
>> +	if (!mdev_state->is_actual_data_sent) {
>> +
>> +		/* create actual data packet */
>> +		write_to_packet(mdev_state->pkt, (u8 *)&mdev_state->nr_ports,
>> +				sizeof(mdev_state->nr_ports));
>> +		write_to_packet(mdev_state->pkt, (u8 *)&mdev_state->s,
>> +				sizeof(struct serial_port) * 2);
>> +
>> +		write_to_packet(mdev_state->pkt, mdev_state->vconfig,
>> +				MTTY_CONFIG_SPACE_SIZE);
>> +
>> +		write_to_packet(mdev_state->pkt, (u8 *)mdev_state->gpfn_to_hpfn,
>> +				sizeof(unsigned long) * MAX_GPFN_COUNT);
>> +
>> +		mdev_state->pkt->id = PACKET_ID;
>> +		mdev_state->pkt->flags = PACKET_FLAGS_ACTUAL_DATA;
>> +
>> +		mdev_state->is_actual_data_sent = true;
>> +	} else {
>> +		/* create dummy data packet */
>> +		if (mdev_state->dummy_data_size > user_dummy_data_size) {
>> +			*pending = 0;
>> +			mdev_state->packet_state = PACKET_STATE_NONE;
>> +			return 0;
>> +		}
>> +
>> +		memset(mdev_state->pkt->data, 0xa5, PACKET_DATA_SIZE_MAX);
>> +
>> +		mdev_state->pkt->id = PACKET_ID;
>> +		mdev_state->pkt->flags = PACKET_FLAGS_DUMMY_DATA;
>> +		mdev_state->pkt->data_size = PACKET_DATA_SIZE_MAX;
>> +		mdev_state->dummy_data_size += PACKET_DATA_SIZE_MAX;
>> +	}
>> +
>> +	*pending = sizeof(struct packet) + mdev_state->pkt->data_size;
>> +	mdev_state->packet_state = PACKET_STATE_PREPARED;
>> +	mdev_state->saved_size = 0;
>> +
>> +	return 0;
>> +}
>> +
>> +static int copy_device_data(struct mdev_state *mdev_state)
>> +{
>> +	u64 size;
>> +
>> +	if (!mdev_state->pkt || !mdev_state->mig_region_base)
>> +		return -EINVAL;
>> +
>> +	if (mdev_state->packet_state == PACKET_STATE_COPIED)
>> +		return 0;
>> +
>> +	if (!mdev_state->pkt->data_size)
>> +		return 0;
>> +
>> +	size = sizeof(struct packet) + mdev_state->pkt->data_size;
>> +
>> +	memcpy(mdev_state->mig_region_base, mdev_state->pkt, size);
>> +
> if data area is mmaped, who is going to copy data from mdev_state->pkt
> to mdev_state->mig_region_base ?
> actually, I do see this area is mmaped in this sample.
> 

This area ia mmap and is backed by memory, see mtty_mmap(), on read 
access to data_offset, packet data is copied to mmaped memory.

>> +	mdev_state->saved_size = size;
>> +	mdev_state->packet_state = PACKET_STATE_COPIED;
>> +	memset(mdev_state->pkt, 0, sizeof(struct packet));
>> +	return 0;
>> +}
>> +
>> +static int resume_device_data(struct mdev_state *mdev_state, u64 data_size)
>> +{
>> +	unsigned long i;
>> +
>> +	if (mdev_state->device_state != VFIO_DEVICE_STATE_RESUMING)
>> +		return -EINVAL;
>> +
>> +	if (!mdev_state->pkt || !mdev_state->mig_region_base)
>> +		return -EINVAL;
>> +
>> +	memcpy(mdev_state->pkt, mdev_state->mig_region_base, data_size);
>> +
>> +	if (mdev_state->pkt->flags & PACKET_FLAGS_ACTUAL_DATA) {
>> +		int index = 0;
>> +		/* restore device data */
>> +		read_from_packet(mdev_state->pkt, (u8 *)&mdev_state->nr_ports,
>> +				 index, sizeof(mdev_state->nr_ports));
>> +		index += sizeof(mdev_state->nr_ports);
>> +
>> +		read_from_packet(mdev_state->pkt, (u8 *)&mdev_state->s,
>> +				index, sizeof(struct serial_port) * 2);
>> +		index += sizeof(struct serial_port) * 2;
>> +
>> +		read_from_packet(mdev_state->pkt, mdev_state->vconfig,
>> +				 index, MTTY_CONFIG_SPACE_SIZE);
>> +		index += MTTY_CONFIG_SPACE_SIZE;
>> +
>> +		read_from_packet(mdev_state->pkt,
>> +				(u8 *)mdev_state->gpfn_to_hpfn,
>> +				index, sizeof(unsigned long) * MAX_GPFN_COUNT);
>> +		index += sizeof(unsigned long) * MAX_GPFN_COUNT;
>> +
>> +		for (i = 0; i < MAX_GPFN_COUNT; i++) {
>> +			if (mdev_state->gpfn_to_hpfn[i] != PFN_NULL) {
>> +				int ret;
>> +				unsigned long hpfn;
>> +
>> +				ret = vfio_pin_pages(mdev_dev(mdev_state->mdev),
>> +				       &i, 1, IOMMU_READ | IOMMU_WRITE, &hpfn);
>> +				if (ret <= 0) {
>> +					pr_err("%s: 0x%lx unpin error %d\n",
>> +							__func__, i, ret);
>> +					continue;
>> +				}
>> +				mdev_state->gpfn_to_hpfn[i] = hpfn;
>> +			}
>> +		}
>> +	} else {
>> +#if defined(DEBUG)
>> +		pr_info("%s: %s discard data 0x%llx\n",
>> +			 __func__, dev_name(mdev_dev(mdev_state->mdev)),
>> +			data_size);
>> +#endif
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int handle_mig_read(unsigned int index, struct mdev_state *mdev_state,
>> +			   loff_t offset, u8 *buf, u32 count)
>> +{
>> +	int ret = 0;
>> +	u64 pending = 0;
>> +
>> +	switch (offset) {
>> +	case MIGRATION_INFO_OFFSET(device_state):	// 0x00
>> +		*(u32 *)buf = get_device_state(mdev_state);
>> +		break;
>> +
>> +	case MIGRATION_INFO_OFFSET(pending_bytes):	// 0x08
>> +		ret = save_device_data(mdev_state, &pending);
>> +		if (ret)
>> +			break;
>> +		*(u64 *)buf = pending;
>> +		break;
>> +
>> +	case MIGRATION_INFO_OFFSET(data_offset):	// 0x10
>> +		if (mdev_state->device_state & VFIO_DEVICE_STATE_SAVING) {
>> +			ret = copy_device_data(mdev_state);
>> +			if (ret)
>> +				break;
>> +		}
>> +		*(u64 *)buf = MTTY_MIGRATION_REGION_DATA_OFFSET;
> what is this?

I think macro is self explanatory, its data offset within migration 
region where vendor driver has copied data and user application should 
data from this offset of migration region.

Thanks,
Kirti
