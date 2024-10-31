Return-Path: <kvm+bounces-30167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EB489B78ED
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 11:45:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21ADF1F24F55
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 10:45:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E299719994D;
	Thu, 31 Oct 2024 10:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gXb5rgHp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E9B83CD9;
	Thu, 31 Oct 2024 10:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730371541; cv=none; b=Ea4oWI5pAl3D92ZhxuJvCJpQ0AW4kwkM8VD+WYOyVfFLcvD5hozB6OK8HEZusuJSa7ZW1KpfbxeDreJpkpqj3D184yZtd8iKF0XVXtdfIfKnCDNAf2WN9zdi+7NIb3x73vcWhZ3IIQK7PwXiRkfO/VdQDBP03oLH0u46Tuv1V+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730371541; c=relaxed/simple;
	bh=J0lBZniKTaYEzckyEAV7RWTIBs3KnKUaGugySpgf+dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0dc4ltQJgydwK9Y0PbE63MMTMrSWqfFBJ2G88pRMvq+nadjRuAM1CI6gj75g7/LcFPHAZoFBu4DTsT4fuiZC3pf3zSqejGBUe2OmP/XuoQ1qWFopf/mMFz87kEwJp3OHzaaQvZxRIgAcgyomWxPZX6v+e/yra80nvUE+n+DhzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gXb5rgHp; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730371538; x=1761907538;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J0lBZniKTaYEzckyEAV7RWTIBs3KnKUaGugySpgf+dE=;
  b=gXb5rgHprdm3B4m44h73vuc+/SomRM6uc9++y7HLDlQaphKxfuo/H7gk
   a0QgnfAuP84HXz9O74hakNXQamhB4MWV1EW1XlGLYkBe8pHFjKh78IE2V
   FwddsI+zSqIpNpl6NJJ3VMZP/v7zAAI+m+g/FIQVJoiYjaFPYz5kAP6jX
   JAhNu0PPtlIFGYxcvTAdF/ZH2z83nLJ3IRtGBtOL+Jnf95Y+iUVlXYDr3
   qh+hOMW6CPDEsnwVLDvHd03lfDoIVmYoaJjfZoY511WuUiySkIXrPzxQN
   NROVI1Cez7WvGgfSdLd7U79maBZppMTtxrFFuiL53iSNSWqsEgsNx9mKn
   A==;
X-CSE-ConnectionGUID: mO7Xp/UHR/uaBXsBDGPQdw==
X-CSE-MsgGUID: RzH16BsTSSyYDJVwaC7gCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="55501321"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="55501321"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 03:45:37 -0700
X-CSE-ConnectionGUID: YuNARll7SUaFHR0hRuAGuQ==
X-CSE-MsgGUID: fNJz6c39RpeQ3aQwkz75Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="83396329"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.21])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 03:44:57 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	dan.j.williams@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	nik.borisov@suse.com,
	kai.huang@intel.com
Subject: [PATCH 9/8] x86/virt/tdx: Add the global metadata code generation script
Date: Thu, 31 Oct 2024 23:44:33 +1300
Message-ID: <20241031104433.855336-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730118186.git.kai.huang@intel.com>
References: <cover.1730118186.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paolo Bonzini <pbonzini@redhat.com>

Currently, the global metadata reading code is auto-generated by a
script [1].  Future work to support KVM TDX will need to read more
fields thus will need to regenerate the metadata reading code.

Add the script to the kernel tree to keep it under track [2].

Note the script has some minor updates (to make it more readable)
comparing to [1] but they don't change the generated code.  Also change
the name to tdx_global_metadata.py to make it more specific.

Link: https://lore.kernel.org/0853b155ec9aac09c594caa60914ed6ea4dc0a71.camel@intel.com/ [1]
Link: https://lore.kernel.org/CABgObfZWjGc0FT2My_oEd6V8ZxYHD-RejndbU_FipuADgJkFbw@mail.gmail.com/ [2]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 MAINTAINERS                    |   1 +
 scripts/tdx_global_metadata.py | 187 +++++++++++++++++++++++++++++++++
 2 files changed, 188 insertions(+)
 create mode 100644 scripts/tdx_global_metadata.py

diff --git a/MAINTAINERS b/MAINTAINERS
index cf02cbf4bef1..fc983bc02109 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24987,6 +24987,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/core
 F:	Documentation/arch/x86/
 F:	Documentation/devicetree/bindings/x86/
 F:	arch/x86/
+F:	scripts/tdx_global_metadata.py
 F:	tools/testing/selftests/x86
 
 X86 CPUID DATABASE
diff --git a/scripts/tdx_global_metadata.py b/scripts/tdx_global_metadata.py
new file mode 100644
index 000000000000..7f5cc13b1d78
--- /dev/null
+++ b/scripts/tdx_global_metadata.py
@@ -0,0 +1,187 @@
+#! /usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+import json
+import sys
+
+# Note: this script does not run as part of the build process.
+# It is used to generate structs from the TDX global_metadata.json
+# file, and functions to fill in said structs.  Rerun it if
+# you need more fields.
+
+TDX_STRUCTS = {
+    "version": [
+        "BUILD_DATE",
+        "BUILD_NUM",
+        "MINOR_VERSION",
+        "MAJOR_VERSION",
+        "UPDATE_VERSION",
+        "INTERNAL_VERSION",
+    ],
+    "features": [
+        "TDX_FEATURES0"
+    ],
+    "tdmr": [
+        "MAX_TDMRS",
+        "MAX_RESERVED_PER_TDMR",
+        "PAMT_4K_ENTRY_SIZE",
+        "PAMT_2M_ENTRY_SIZE",
+        "PAMT_1G_ENTRY_SIZE",
+    ],
+    "cmr": [
+        "NUM_CMRS", "CMR_BASE", "CMR_SIZE"
+    ],
+}
+
+STRUCT_PREFIX = "tdx_sys_info"
+FUNC_PREFIX = "get_tdx_sys_info"
+STRVAR_PREFIX = "sysinfo"
+
+def print_class_struct_field(field_name, element_bytes, num_fields, num_elements, file):
+    element_type = "u%s" % (element_bytes * 8)
+    element_array = ""
+    if num_fields > 1:
+        element_array += "[%d]" % (num_fields)
+    if num_elements > 1:
+        element_array += "[%d]" % (num_elements)
+    print("\t%s %s%s;" % (element_type, field_name, element_array), file=file)
+
+def print_class_struct(class_name, fields, file):
+    struct_name = "%s_%s" % (STRUCT_PREFIX, class_name)
+    print("struct %s {" % (struct_name), file=file)
+    for f in fields:
+        print_class_struct_field(
+            f["Field Name"].lower(),
+            int(f["Element Size (Bytes)"]),
+            int(f["Num Fields"]),
+            int(f["Num Elements"]),
+            file=file)
+    print("};", file=file)
+
+def print_read_field(field_id, struct_var, struct_member, indent, file):
+    print(
+        "%sif (!ret && !(ret = read_sys_metadata_field(%s, &val)))\n%s\t%s->%s = val;"
+        % (indent, field_id, indent, struct_var, struct_member),
+        file=file,
+    )
+
+def print_class_function(class_name, fields, file):
+    func_name = "%s_%s" % (FUNC_PREFIX, class_name)
+    struct_name = "%s_%s" % (STRUCT_PREFIX, class_name)
+    struct_var = "%s_%s" % (STRVAR_PREFIX, class_name)
+
+    print("static int %s(struct %s *%s)" % (func_name, struct_name, struct_var), file=file)
+    print("{", file=file)
+    print("\tint ret = 0;", file=file)
+    print("\tu64 val;", file=file)
+
+    has_i = 0
+    has_j = 0
+    for f in fields:
+        num_fields = int(f["Num Fields"])
+        num_elements = int(f["Num Elements"])
+        if num_fields > 1:
+            has_i = 1
+        if num_elements > 1:
+            has_j = 1
+
+    if has_i == 1 and has_j == 1:
+        print("\tint i, j;", file=file)
+    elif has_i == 1:
+        print("\tint i;", file=file)
+
+    print(file=file)
+    for f in fields:
+        fname = f["Field Name"]
+        field_id = f["Base FIELD_ID (Hex)"]
+        num_fields = int(f["Num Fields"])
+        num_elements = int(f["Num Elements"])
+        struct_member = fname.lower()
+        indent = "\t"
+        if num_fields > 1:
+            if fname == "CMR_BASE" or fname == "CMR_SIZE":
+                limit = "%s_%s->num_cmrs" %(STRVAR_PREFIX, "cmr")
+            elif fname == "CPUID_CONFIG_LEAVES" or fname == "CPUID_CONFIG_VALUES":
+                limit = "%s_%s->num_cpuid_config" %(STRVAR_PREFIX, "td_conf")
+            else:
+                limit = "%d" %(num_fields)
+            print("%sfor (i = 0; i < %s; i++)" % (indent, limit), file=file)
+            indent += "\t"
+            field_id += " + i"
+            struct_member += "[i]"
+        if num_elements > 1:
+            print("%sfor (j = 0; j < %d; j++)" % (indent, num_elements), file=file)
+            indent += "\t"
+            field_id += " * 2 + j"
+            struct_member += "[j]"
+
+        print_read_field(
+            field_id,
+            struct_var,
+            struct_member,
+            indent,
+            file=file,
+        )
+
+    print(file=file)
+    print("\treturn ret;", file=file)
+    print("}", file=file)
+
+def print_main_struct(file):
+    print("struct tdx_sys_info {", file=file)
+    for class_name, field_names in TDX_STRUCTS.items():
+        struct_name = "%s_%s" % (STRUCT_PREFIX, class_name)
+        struct_var = class_name
+        print("\tstruct %s %s;" % (struct_name, struct_var), file=file)
+    print("};", file=file)
+
+def print_main_function(file):
+    print("static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)", file=file)
+    print("{", file=file)
+    print("\tint ret = 0;", file=file)
+    print(file=file)
+    for class_name, field_names in TDX_STRUCTS.items():
+        func_name = "%s_%s" % (FUNC_PREFIX, class_name)
+        struct_var = class_name
+        print("\tret = ret ?: %s(&sysinfo->%s);" % (func_name, struct_var), file=file)
+    print(file=file)
+    print("\treturn ret;", file=file)
+    print("}", file=file)
+
+jsonfile = sys.argv[1]
+hfile = sys.argv[2]
+cfile = sys.argv[3]
+hfileifdef = hfile.replace(".", "_")
+
+with open(jsonfile, "r") as f:
+    json_in = json.load(f)
+    fields = {x["Field Name"]: x for x in json_in["Fields"]}
+
+with open(hfile, "w") as f:
+    print("/* SPDX-License-Identifier: GPL-2.0 */", file=f)
+    print("/* Automatically generated TDX global metadata structures. */", file=f)
+    print("#ifndef _X86_VIRT_TDX_AUTO_GENERATED_" + hfileifdef.upper(), file=f)
+    print("#define _X86_VIRT_TDX_AUTO_GENERATED_" + hfileifdef.upper(), file=f)
+    print(file=f)
+    print("#include <linux/types.h>", file=f)
+    print(file=f)
+    for class_name, field_names in TDX_STRUCTS.items():
+        print_class_struct(class_name, [fields[x] for x in field_names], file=f)
+        print(file=f)
+    print_main_struct(file=f)
+    print(file=f)
+    print("#endif", file=f)
+
+with open(cfile, "w") as f:
+    print("// SPDX-License-Identifier: GPL-2.0", file=f)
+    print("/*", file=f)
+    print(" * Automatically generated functions to read TDX global metadata.", file=f)
+    print(" *", file=f)
+    print(" * This file doesn't compile on its own as it lacks of inclusion", file=f)
+    print(" * of SEAMCALL wrapper primitive which reads global metadata.", file=f)
+    print(" * Include this file to other C file instead.", file=f)
+    print(" */", file=f)
+    for class_name, field_names in TDX_STRUCTS.items():
+        print(file=f)
+        print_class_function(class_name, [fields[x] for x in field_names], file=f)
+    print(file=f)
+    print_main_function(file=f)
-- 
2.46.2


