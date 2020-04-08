Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282141A1B3F
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgDHFF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:05:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38728 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgDHFFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:05:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03853ldR191183;
        Wed, 8 Apr 2020 05:05:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=9tI0JiEef8to344a69A5BaCsrTLQkt/TJVKmTnFs63o=;
 b=cymcX7cssNqc00recnMFSS2WRHjmFb+WkYX/rdlb2DTEEo/1m5i0n7hDKVgpoqne9dgn
 qV1fq5CSllni2nW8Do8aEIZhVjZ8agzgViY1rUV1JF5H+iB6BJ3DhfFb/tj85Neao/JM
 UbaVGFXzb3MRcA0skHvewC8LLUGflolD4ki3Io32ZblIdAcM/dOjL0uK+npq1AsJQpiv
 PSoqZvsLMGnuFEHxqgAokUGAbjWncy15IVg27Xwes+Gn1YoKQe/F9sRwPfea2sYw8xQa
 0v3LPO37oQizGXncjiBA6XzhmWHHck7+6W6fBNpbaWygDfMk5OaOnmcap0yxwdwkaxkI RA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3091m0s0ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03852XvD062260;
        Wed, 8 Apr 2020 05:05:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3091mh1kc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:05 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 038554hD007324;
        Wed, 8 Apr 2020 05:05:04 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:05:04 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 05/26] x86/alternatives: Rename alternatives_smp*, smp_alt_module
Date:   Tue,  7 Apr 2020 22:03:02 -0700
Message-Id: <20200408050323.4237-6-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200408050323.4237-1-ankur.a.arora@oracle.com>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=2 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080037
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename alternatives_smp_module_*(), smp_alt_module to reflect
their new purpose.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/alternative.h | 10 +++---
 arch/x86/kernel/alternative.c      | 54 +++++++++++++++---------------
 arch/x86/kernel/module.c           |  8 ++---
 3 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 8235bbb746d9..db91a7731d87 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -75,11 +75,11 @@ extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
 
 struct module;
 
-extern void alternatives_smp_module_add(struct module *mod, char *name,
-					void *locks, void *locks_end,
-					void *text, void *text_end);
-extern void alternatives_smp_module_del(struct module *mod);
-extern int alternatives_text_reserved(void *start, void *end);
+void alternatives_module_add(struct module *mod, char *name,
+			     void *locks, void *locks_end,
+			     void *text, void *text_end);
+void alternatives_module_del(struct module *mod);
+int alternatives_text_reserved(void *start, void *end);
 #ifdef CONFIG_SMP
 extern void alternatives_enable_smp(void);
 #else
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 32aa1ddf441d..4157f848b537 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -477,7 +477,7 @@ static inline void alternatives_smp_unlock(const s32 *start, const s32 *end,
 					   u8 *text, u8 *text_end) { }
 #endif	/* CONFIG_SMP */
 
-struct smp_alt_module {
+struct alt_module {
 	/* what is this ??? */
 	struct module	*mod;
 	char		*name;
@@ -492,14 +492,14 @@ struct smp_alt_module {
 
 	struct list_head next;
 };
-static LIST_HEAD(smp_alt_modules);
 
-void __init_or_module alternatives_smp_module_add(struct module *mod,
-						  char *name,
-						  void *locks, void *locks_end,
-						  void *text,  void *text_end)
+static LIST_HEAD(alt_modules);
+
+void __init_or_module alternatives_module_add(struct module *mod, char *name,
+					      void *locks, void *locks_end,
+					      void *text,  void *text_end)
 {
-	struct smp_alt_module *smp;
+	struct alt_module *alt;
 
 #ifdef CONFIG_SMP
 	/* Patch to UP if other cpus not imminent. */
@@ -511,36 +511,36 @@ void __init_or_module alternatives_smp_module_add(struct module *mod,
 
 	mutex_lock(&text_mutex);
 
-	smp = kzalloc(sizeof(*smp), GFP_KERNEL | __GFP_NOFAIL);
+	alt = kzalloc(sizeof(*alt), GFP_KERNEL | __GFP_NOFAIL);
 
-	smp->mod	= mod;
-	smp->name	= name;
+	alt->mod	= mod;
+	alt->name	= name;
 
 	if (num_possible_cpus() != 1 || uniproc_patched) {
 		/* Remember only if we'll need to undo it. */
-		smp->locks	= locks;
-		smp->locks_end	= locks_end;
+		alt->locks	= locks;
+		alt->locks_end	= locks_end;
 	}
 
-	smp->text	= text;
-	smp->text_end	= text_end;
+	alt->text	= text;
+	alt->text_end	= text_end;
 	DPRINTK("locks %p -> %p, text %p -> %p, name %s\n",
-		smp->locks, smp->locks_end,
-		smp->text, smp->text_end, smp->name);
+		alt->locks, alt->locks_end,
+		alt->text, alt->text_end, alt->name);
 
-	list_add_tail(&smp->next, &smp_alt_modules);
+	list_add_tail(&alt->next, &alt_modules);
 
 	if (uniproc_patched)
 		alternatives_smp_unlock(locks, locks_end, text, text_end);
 	mutex_unlock(&text_mutex);
 }
 
-void __init_or_module alternatives_smp_module_del(struct module *mod)
+void __init_or_module alternatives_module_del(struct module *mod)
 {
-	struct smp_alt_module *item;
+	struct alt_module *item;
 
 	mutex_lock(&text_mutex);
-	list_for_each_entry(item, &smp_alt_modules, next) {
+	list_for_each_entry(item, &alt_modules, next) {
 		if (mod != item->mod)
 			continue;
 		list_del(&item->next);
@@ -553,7 +553,7 @@ void __init_or_module alternatives_smp_module_del(struct module *mod)
 #ifdef CONFIG_SMP
 void alternatives_enable_smp(void)
 {
-	struct smp_alt_module *mod;
+	struct alt_module *mod;
 
 	/* Why bother if there are no other CPUs? */
 	BUG_ON(num_possible_cpus() == 1);
@@ -565,7 +565,7 @@ void alternatives_enable_smp(void)
 		BUG_ON(num_online_cpus() != 1);
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_UP);
 		clear_cpu_cap(&cpu_data(0), X86_FEATURE_UP);
-		list_for_each_entry(mod, &smp_alt_modules, next)
+		list_for_each_entry(mod, &alt_modules, next)
 			alternatives_smp_lock(mod->locks, mod->locks_end,
 					      mod->text, mod->text_end);
 		uniproc_patched = false;
@@ -580,14 +580,14 @@ void alternatives_enable_smp(void)
  */
 int alternatives_text_reserved(void *start, void *end)
 {
-	struct smp_alt_module *mod;
+	struct alt_module *mod;
 	const s32 *poff;
 	u8 *text_start = start;
 	u8 *text_end = end;
 
 	lockdep_assert_held(&text_mutex);
 
-	list_for_each_entry(mod, &smp_alt_modules, next) {
+	list_for_each_entry(mod, &alt_modules, next) {
 		if (mod->text > text_end || mod->text_end < text_start)
 			continue;
 		for (poff = mod->locks; poff < mod->locks_end; poff++) {
@@ -734,9 +734,9 @@ void __init alternative_instructions(void)
 
 	apply_alternatives(__alt_instructions, __alt_instructions_end);
 
-	alternatives_smp_module_add(NULL, "core kernel",
-				    __smp_locks, __smp_locks_end,
-				    _text, _etext);
+	alternatives_module_add(NULL, "core kernel",
+				__smp_locks, __smp_locks_end,
+				_text, _etext);
 
 	if (!uniproc_patched || num_possible_cpus() == 1) {
 		free_init_pages("SMP alternatives",
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 658ea60ce324..fc3d35198b09 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -251,9 +251,9 @@ int module_finalize(const Elf_Ehdr *hdr,
 	if (locks && text) {
 		void *lseg = (void *)locks->sh_addr;
 		void *tseg = (void *)text->sh_addr;
-		alternatives_smp_module_add(me, me->name,
-					    lseg, lseg + locks->sh_size,
-					    tseg, tseg + text->sh_size);
+		alternatives_module_add(me, me->name,
+					lseg, lseg + locks->sh_size,
+					tseg, tseg + text->sh_size);
 	}
 
 	if (para) {
@@ -278,5 +278,5 @@ int module_finalize(const Elf_Ehdr *hdr,
 
 void module_arch_cleanup(struct module *mod)
 {
-	alternatives_smp_module_del(mod);
+	alternatives_module_del(mod);
 }
-- 
2.20.1

