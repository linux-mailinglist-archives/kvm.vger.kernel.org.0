Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA40D39B083
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 04:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhFDCku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 22:40:50 -0400
Received: from m12-15.163.com ([220.181.12.15]:33881 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFDCku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 22:40:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=VGlqc
        ZU+EgTyA61L0sJmTUeCgixcOEkwANqPM5BiVPQ=; b=cqKAbi72b8cMXRWC0CZWc
        OmEbkWpnsCdzu8dsfwF0n2NcZB9KZ7IMRzAt5F3h45GmtcxpgGph2qTQrvSaPV4p
        bhBAnqKDXM+bnLG1peGJsRvO6hJ/IVjlRJsSnmU1Np/3/y6tbo8CL4jd+Dj3WLTf
        4zAZPvggkd7JehB2avWqOY=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp11 (Coremail) with SMTP id D8CowADHG+Y7krlghxvWDg--.0S2;
        Fri, 04 Jun 2021 10:39:01 +0800 (CST)
From:   13145886936@163.com
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] KVM: Revised the use of space and tabs
Date:   Thu,  3 Jun 2021 19:38:48 -0700
Message-Id: <20210604023848.10549-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: D8CowADHG+Y7krlghxvWDg--.0S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCr1DCr47JFyrWw48Zw4fKrg_yoW5Ar4rpF
        yrGwsrWrWfJr4j9r97JrWq9343Kws7Ka17ArZ7Z3yFvwnrKrn8Ja1kGFW8Zry5J348ZF1S
        ya4FqFyUC3yvyaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bOiSdUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/xtbBzgWng1QHMxhcugAAsx
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Revised the use of space and tabs.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 virt/kvm/kvm_main.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eb440eb1225a..4cec505af62b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -132,7 +132,9 @@ static long kvm_vcpu_compat_ioctl(struct file *file, unsigned int ioctl,
  *   passed to a compat task, let the ioctls fail.
  */
 static long kvm_no_compat_ioctl(struct file *file, unsigned int ioctl,
-				unsigned long arg) { return -EINVAL; }
+				unsigned long arg) {
+				return -EINVAL;
+				}
 
 static int kvm_no_compat_open(struct inode *inode, struct file *file)
 {
@@ -2104,7 +2106,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 * Whoever called remap_pfn_range is also going to call e.g.
 	 * unmap_mapping_range before the underlying pages are freed,
 	 * causing a call to our MMU notifier.
-	 */ 
+	 */
 	kvm_get_pfn(pfn);
 
 out:
@@ -2417,7 +2419,7 @@ static void __kvm_unmap_gfn(struct kvm *kvm,
 	map->page = NULL;
 }
 
-int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map, 
+int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
 		  struct gfn_to_pfn_cache *cache, bool dirty, bool atomic)
 {
 	__kvm_unmap_gfn(vcpu->kvm, gfn_to_memslot(vcpu->kvm, map->gfn), map,
@@ -2576,7 +2578,7 @@ int kvm_vcpu_read_guest(struct kvm_vcpu *vcpu, gpa_t gpa, void *data, unsigned l
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest);
 
 static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			           void *data, int offset, unsigned long len)
+				void *data, int offset, unsigned long len)
 {
 	int r;
 	unsigned long addr;
@@ -2604,8 +2606,8 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
 static int __kvm_write_guest_page(struct kvm *kvm,
-				  struct kvm_memory_slot *memslot, gfn_t gfn,
-			          const void *data, int offset, int len)
+				 struct kvm_memory_slot *memslot, gfn_t gfn,
+				 const void *data, int offset, int len)
 {
 	int r;
 	unsigned long addr;
@@ -2660,7 +2662,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 EXPORT_SYMBOL_GPL(kvm_write_guest);
 
 int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
-		         unsigned long len)
+			 unsigned long len)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	int seg;
@@ -2823,8 +2825,8 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
 void mark_page_dirty_in_slot(struct kvm *kvm,
-			     struct kvm_memory_slot *memslot,
-		 	     gfn_t gfn)
+			 struct kvm_memory_slot *memslot,
+			 gfn_t gfn)
 {
 	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
-- 
2.25.1

