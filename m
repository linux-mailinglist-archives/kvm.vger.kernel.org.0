Return-Path: <kvm+bounces-73234-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UNxvE2vnrGlSvwEAu9opvQ
	(envelope-from <kvm+bounces-73234-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 04:05:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E092B22E615
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 04:05:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7940D303CEA8
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 03:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600FC31AF24;
	Sun,  8 Mar 2026 03:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VRax5P/z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A3424B28;
	Sun,  8 Mar 2026 03:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772939090; cv=none; b=f4ZpliMSeBkxqNJ86/JBd1Wi4PMuv4wL5GNLHU+qfNnIyGgpUx5IPtaQX0edYNzPY0DB/gWmYcRUoYQmSNixDYY9xfVvYIuUeIgksECg8LeCWbQmrkaOQ4twykYmHBYpgBFSzS/mh7MtudrzDhiG+grrukFz/PvoUgLvibcHlkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772939090; c=relaxed/simple;
	bh=SOH99pkPWxLY+LxD4i1QK5JyubhYxu2fvavHq2wOGlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jH8LC/xuvF0APBs0n7kWJEt9qkqKbzYfAjfQYEmsMmgULgTzYeaW6vGXr6OeiT38KH0XrI/OAAZ4DeNlW02XKgflK4QBG1IF/92pQgmNhNRyxtqIoqVlfczz5lsGF8aHxEs6POOjudTUSlWC6/6pyIjgJzkeerjq7JyysB+RKk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VRax5P/z; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 627NOGOH3235469;
	Sun, 8 Mar 2026 03:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=SC2eg7UOHq1pRP0/v
	EprahfrAV7USBOZe9K1c1VEa8k=; b=VRax5P/zi6GaID4Qh8fiye3s6C4zyI6kb
	Ta1ZrStbdTDlDpXGM40jK/RlYSFacTuymnXCbO2eLhgxCBSrhaoo9n6JXCd5MVrO
	N2ZtL9IEAF3Isfis1zlUW0j+W+9NCnma7qkdh7aaqtTEszpmQ7M0sI9fR/bjMI0f
	haMFwgQKB2bFDpNL4M2EAIGGr1u/zXlhVRMeR0kof0IYxyRn2ux1FvqmofP+rGWw
	4lZDHqwy4ro6lpiDYsPiFDCec2vu5lp5CFeUJE4Ju0pOX666m5MmllHPJ1BTkpG1
	8JH1FS41YUjZb9l/3EiupdgtAmjgPjV77d2EZL8z0X/3BG/bp9cDw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcvr2ft9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 03:04:45 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6280bXDU009505;
	Sun, 8 Mar 2026 03:04:44 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4crxqy0an1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 03:04:44 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62834hdG15532582
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 8 Mar 2026 03:04:43 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 56E4158058;
	Sun,  8 Mar 2026 03:04:43 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 84CF658057;
	Sun,  8 Mar 2026 03:04:42 +0000 (GMT)
Received: from 9.60.13.83 (unknown [9.60.13.83])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sun,  8 Mar 2026 03:04:42 +0000 (GMT)
From: Douglas Freimuth <freimuth@linux.ibm.com>
To: borntraeger@linux.ibm.com, imbrenda@linux.ibm.com, frankja@linux.ibm.com,
        david@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mjrosato@linux.ibm.com, freimuth@linux.ibm.com
Subject: [PATCH v1 1/3] Add map/unmap ioctl and clean mappings post-guest
Date: Sun,  8 Mar 2026 04:04:36 +0100
Message-ID: <20260308030438.88580-2-freimuth@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260308030438.88580-1-freimuth@linux.ibm.com>
References: <20260308030438.88580-1-freimuth@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA4MDAyNiBTYWx0ZWRfX0RQyci0PfNKC
 WMDbExmIYe8LvAWj75MM46hJcXZGEQmaWl7YqRn6RoLR/numdsMkgZveiCgwadqqled4mVSNAom
 AgMQWmnuU4L65P5QtmG/17wvJRMyTVWG6HVzFT8bBSAIcwcL7/yYn3Kz0df1waVK0TAe9JO0wcb
 uSItc0x3ew+28UpEEe5UvBYnY0GxLeUiNtj9v6TD9vg6O+he/I3+G5xBn/vne/Lj0wHyWCgl8sX
 6vutdT9CumSTBa2JkOFUIN6UJrP0qRaXceaCsSkXiVaVaDfJVuclyrahdVkj0VgY53WeTQ7rLeF
 X3oiGeWnz4YLO4bZ7l4q3PdDCN+cZCAbt5u1RWXZZGTKl/0uZp7AK3vFtJbu78xArDkW3pZ0VvN
 aQwdL51roScl3Bgdc8z2S6NhXEEwsSa8Tam8QBRPbP3xC64HO2Z4CZZpeYpwG4ObzYrQraOIvK9
 i3shJXxCc6L2E8FmNBg==
X-Proofpoint-GUID: oTgqjZTeb3VomZOMyqZuWwNsadVGGWrH
X-Proofpoint-ORIG-GUID: oTgqjZTeb3VomZOMyqZuWwNsadVGGWrH
X-Authority-Analysis: v=2.4 cv=QoFTHFyd c=1 sm=1 tr=0 ts=69ace74d cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=8Mf9-W6H7kIZzL-AiSkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-08_01,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1011 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603080026
X-Rspamd-Queue-Id: E092B22E615
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73234-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[freimuth@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.988];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

Patch 1: This patch adds map/unmap ioctls which map the adapter set
indicator pages so the pages can be accessed when interrupts are
disabled. The mappings are cleaned up when the guest is removed.

Fencing of Fast Inject in Secure Execution environments is enabled in
this patch by not mapping adapter indicator pages. In Secure Execution
environments the path of execution available before this patch is followed.
Statistical counters to count map/unmap functions for adapter indicator
pages are added in this patch. The counters can be used to analyze
map/unmap functions in non-Secure Execution environments and similarly
can be used to analyze Secure Execution environments where the counters
should not be incremented as the adapter indicator pages are not mapped.

Signed-off-by: Douglas Freimuth <freimuth@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |   5 ++
 arch/s390/kvm/interrupt.c        | 143 +++++++++++++++++++++++++------
 arch/s390/kvm/kvm-s390.c         |   2 +
 3 files changed, 124 insertions(+), 26 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 64a50f0862aa..616be8ca4614 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -448,6 +448,8 @@ struct kvm_vcpu_arch {
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
 	u64 inject_io;
+	u64 io_390_adapter_map;
+	u64 io_390_adapter_unmap;
 	u64 inject_float_mchk;
 	u64 inject_pfault_done;
 	u64 inject_service_signal;
@@ -479,6 +481,9 @@ struct s390_io_adapter {
 	bool masked;
 	bool swap;
 	bool suppressible;
+	struct rw_semaphore maps_lock;
+	struct list_head maps;
+	unsigned int nr_maps;
 };
 
 #define MAX_S390_IO_ADAPTERS ((MAX_ISC + 1) * 8)
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 18932a65ca68..cafc03e20f8f 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2426,6 +2426,9 @@ static int register_io_adapter(struct kvm_device *dev,
 	if (!adapter)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&adapter->maps);
+	init_rwsem(&adapter->maps_lock);
+	adapter->nr_maps = 0;
 	adapter->id = adapter_info.id;
 	adapter->isc = adapter_info.isc;
 	adapter->maskable = adapter_info.maskable;
@@ -2450,12 +2453,103 @@ int kvm_s390_mask_adapter(struct kvm *kvm, unsigned int id, bool masked)
 	return ret;
 }
 
+static struct page *get_map_page(struct kvm *kvm, u64 uaddr)
+{
+	struct mm_struct *mm = kvm->mm;
+	struct page *page = NULL;
+	int locked = 1;
+
+	if (mmget_not_zero(mm)) {
+		mmap_read_lock(mm);
+		get_user_pages_remote(mm, uaddr, 1, FOLL_WRITE,
+				      &page, &locked);
+		if (locked)
+			mmap_read_unlock(mm);
+		mmput(mm);
+	}
+
+	return page;
+}
+
+static int kvm_s390_adapter_map(struct kvm *kvm, unsigned int id, __u64 addr)
+{
+	struct s390_io_adapter *adapter = get_io_adapter(kvm, id);
+	struct s390_map_info *map;
+	unsigned long flags;
+	int ret;
+
+	if (!adapter || !addr)
+		return -EINVAL;
+
+	map = kzalloc_obj(*map, GFP_KERNEL);
+	if (!map)
+		return -ENOMEM;
+
+	map->page = get_map_page(kvm, addr);
+	if (!map->page) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	INIT_LIST_HEAD(&map->list);
+	map->guest_addr = addr;
+	map->addr = addr;
+	down_write(&adapter->maps_lock);
+	if (adapter->nr_maps++ < MAX_S390_ADAPTER_MAPS) {
+		list_add_tail(&map->list, &adapter->maps);
+		ret = 0;
+	} else {
+		put_page(map->page);
+		ret = -EINVAL;
+	}
+	up_write(&adapter->maps_lock);
+out:
+	if (ret)
+		kfree(map);
+	return ret;
+}
+
+static int kvm_s390_adapter_unmap(struct kvm *kvm, unsigned int id, __u64 addr)
+{
+	struct s390_io_adapter *adapter = get_io_adapter(kvm, id);
+	struct s390_map_info *map, *tmp;
+	int found = 0;
+
+	if (!adapter || !addr)
+		return -EINVAL;
+
+	down_write(&adapter->maps_lock);
+	list_for_each_entry_safe(map, tmp, &adapter->maps, list) {
+		if (map->guest_addr == addr) {
+			found = 1;
+			adapter->nr_maps--;
+			list_del(&map->list);
+			put_page(map->page);
+			kfree(map);
+			break;
+		}
+	}
+	up_write(&adapter->maps_lock);
+
+	return found ? 0 : -ENOENT;
+}
+
 void kvm_s390_destroy_adapters(struct kvm *kvm)
 {
 	int i;
+	struct s390_map_info *map, *tmp;
 
-	for (i = 0; i < MAX_S390_IO_ADAPTERS; i++)
+	for (i = 0; i < MAX_S390_IO_ADAPTERS; i++) {
+		if (!kvm->arch.adapters[i])
+			continue;
+		list_for_each_entry_safe(map, tmp,
+					 &kvm->arch.adapters[i]->maps, list) {
+			list_del(&map->list);
+			put_page(map->page);
+			kfree(map);
+		}
 		kfree(kvm->arch.adapters[i]);
+	}
 }
 
 static int modify_io_adapter(struct kvm_device *dev,
@@ -2463,7 +2557,8 @@ static int modify_io_adapter(struct kvm_device *dev,
 {
 	struct kvm_s390_io_adapter_req req;
 	struct s390_io_adapter *adapter;
-	int ret;
+	__u64 host_addr;
+	int ret, idx;
 
 	if (copy_from_user(&req, (void __user *)attr->addr, sizeof(req)))
 		return -EFAULT;
@@ -2477,14 +2572,28 @@ static int modify_io_adapter(struct kvm_device *dev,
 		if (ret > 0)
 			ret = 0;
 		break;
-	/*
-	 * The following operations are no longer needed and therefore no-ops.
-	 * The gpa to hva translation is done when an IRQ route is set up. The
-	 * set_irq code uses get_user_pages_remote() to do the actual write.
-	 */
 	case KVM_S390_IO_ADAPTER_MAP:
 	case KVM_S390_IO_ADAPTER_UNMAP:
-		ret = 0;
+		mutex_lock(&dev->kvm->lock);
+		if (kvm_s390_pv_is_protected(dev->kvm)) {
+			mutex_unlock(&dev->kvm->lock);
+			break;
+		}
+		mutex_unlock(&dev->kvm->lock);
+		idx = srcu_read_lock(&dev->kvm->srcu);
+		host_addr = gpa_to_hva(dev->kvm, req.addr);
+		if (kvm_is_error_hva(host_addr)) {
+			srcu_read_unlock(&dev->kvm->srcu, idx);
+			return -EFAULT;
+			}
+		srcu_read_unlock(&dev->kvm->srcu, idx);
+		if (req.type == KVM_S390_IO_ADAPTER_MAP) {
+			dev->kvm->stat.io_390_adapter_map++;
+			ret = kvm_s390_adapter_map(dev->kvm, req.id, host_addr);
+		} else {
+			dev->kvm->stat.io_390_adapter_unmap++;
+			ret = kvm_s390_adapter_unmap(dev->kvm, req.id, host_addr);
+		}
 		break;
 	default:
 		ret = -EINVAL;
@@ -2727,24 +2836,6 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
 	return swap ? (bit ^ (BITS_PER_LONG - 1)) : bit;
 }
 
-static struct page *get_map_page(struct kvm *kvm, u64 uaddr)
-{
-	struct mm_struct *mm = kvm->mm;
-	struct page *page = NULL;
-	int locked = 1;
-
-	if (mmget_not_zero(mm)) {
-		mmap_read_lock(mm);
-		get_user_pages_remote(mm, uaddr, 1, FOLL_WRITE,
-				      &page, &locked);
-		if (locked)
-			mmap_read_unlock(mm);
-		mmput(mm);
-	}
-
-	return page;
-}
-
 static int adapter_indicators_set(struct kvm *kvm,
 				  struct s390_io_adapter *adapter,
 				  struct kvm_s390_adapter_int *adapter_int)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bc7d6fa66eaf..8e6532f55a5a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -68,6 +68,8 @@
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
 	STATS_DESC_COUNTER(VM, inject_io),
+	STATS_DESC_COUNTER(VM, io_390_adapter_map),
+	STATS_DESC_COUNTER(VM, io_390_adapter_unmap),
 	STATS_DESC_COUNTER(VM, inject_float_mchk),
 	STATS_DESC_COUNTER(VM, inject_pfault_done),
 	STATS_DESC_COUNTER(VM, inject_service_signal),
-- 
2.52.0


