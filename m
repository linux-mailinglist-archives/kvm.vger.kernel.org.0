Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95063440D47
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 06:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhJaF7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 01:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhJaF7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Oct 2021 01:59:10 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6E6C061570
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 22:56:39 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id g11so1919658pfv.7
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 22:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NWDKpsQFk5mN1jQnrTsnd6C8/vgl4oVD+4bLDzSVTA4=;
        b=JSsw0ms06SHHSeKWgvkZWXXDzdj5SVZCpQJ/TFP2CZZyk6yEb5zK0Z8HJ+KjWAt5BA
         2P1LYDKXl7yCpoyG6jnXeiCU1G+hYzW8Rte3UeMuEE3rf4pOEfLQ7F6bMb8Lx/Htpv+W
         1oDwtMxvm+q9XQkuwHTKEjbV4eOvDJJ15Y1xSUTi5C+NdO7AV8m9CNyy9JHVJLbmJECF
         hIUcmYepUmlyz3pwxQjGjX/TUDq7hKtbD6rrSp+PTdNt9bPDHob3FPogq8xeles0npCN
         mYs9oY8ojs0O+hLPQqMO8m4d2X1tks2pc8klcgVL4ygtlUvQA2W0NVFoIb7nTHCgJRjg
         GZbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NWDKpsQFk5mN1jQnrTsnd6C8/vgl4oVD+4bLDzSVTA4=;
        b=v3ThcnaOWrsuh/VfC78xDO2cNlug39cevrRWSfVpuIrpNMcnZ3If1UfrZnXFAiVY42
         Fdyru91BfECw1SvtS6XDuvrXCrbeHxL5gSp6CEf8NALjK6dhElV/Ve91ffwjdyrQ94G/
         CMNdQKdJ63RilcXjSXF7OnFLyAKemc1+MS5vRm8kV6FB+aTuo07ckw5hg/ia40Cgf/bi
         PYvHZGMY67g4vvjsGvjV2XFR2WYRBzEtBrPG+EPVCgt2Bv5N+EwpTccoFmpSWTVv1D+N
         vMT0msUMtlfMeNkuMhFlKVoEE36mB55bQUv5RFiHm5fWgpwUTZkIt60Dotg0zzw3fCy4
         hNmw==
X-Gm-Message-State: AOAM533OpeXTdQzAMAyybO80rmHLBHP7Hpj/Sz8FIWKd5iF6DrbckW04
        49MWjVqSMWEbur7biu4wwuoZKBIXSpRUtQ==
X-Google-Smtp-Source: ABdhPJz0kW32yXobgsRM1QEeGYMt3MP5wp24vI+FYz2meZEpmDb6mzxeNiMnJGy7Cuti85ZacCOvyw==
X-Received: by 2002:a63:f11:: with SMTP id e17mr2640996pgl.448.1635659798658;
        Sat, 30 Oct 2021 22:56:38 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id j19sm11403179pfj.127.2021.10.30.22.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 22:56:38 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v1 1/7] x86 UEFI: Remove mixed_mode
Date:   Sat, 30 Oct 2021 22:56:28 -0700
Message-Id: <20211031055634.894263-2-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211031055634.894263-1-zxwang42@gmail.com>
References: <20211031055634.894263-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zxwang42@gmail.com>

Remove the mixed_mode code from efi.h as we are not supporting i386 UEFI
for now.

Signed-off-by: Zixuan Wang <zxwang42@gmail.com>
---
 lib/linux/efi.h | 317 +++++++++++++++---------------------------------
 1 file changed, 100 insertions(+), 217 deletions(-)

diff --git a/lib/linux/efi.h b/lib/linux/efi.h
index 7ac1082..455625a 100644
--- a/lib/linux/efi.h
+++ b/lib/linux/efi.h
@@ -62,15 +62,7 @@ typedef guid_t efi_guid_t;
 
 typedef struct {
 	efi_guid_t guid;
-	u32 table;
-} efi_config_table_32_t;
-
-typedef union {
-	struct {
-		efi_guid_t guid;
-		void *table;
-	};
-	efi_config_table_32_t mixed_mode;
+	void *table;
 } efi_config_table_t;
 
 /*
@@ -251,127 +243,76 @@ typedef struct efi_generic_dev_path efi_device_path_protocol_t;
 /*
  * EFI Boot Services table
  */
-union efi_boot_services {
-	struct {
-		efi_table_hdr_t hdr;
-		void *raise_tpl;
-		void *restore_tpl;
-		efi_status_t (__efiapi *allocate_pages)(int, int, unsigned long,
-							efi_physical_addr_t *);
-		efi_status_t (__efiapi *free_pages)(efi_physical_addr_t,
-						    unsigned long);
-		efi_status_t (__efiapi *get_memory_map)(unsigned long *, void *,
-							unsigned long *,
-							unsigned long *, u32 *);
-		efi_status_t (__efiapi *allocate_pool)(int, unsigned long,
-						       void **);
-		efi_status_t (__efiapi *free_pool)(void *);
-		efi_status_t (__efiapi *create_event)(u32, unsigned long,
-						      efi_event_notify_t, void *,
-						      efi_event_t *);
-		efi_status_t (__efiapi *set_timer)(efi_event_t,
-						  EFI_TIMER_DELAY, u64);
-		efi_status_t (__efiapi *wait_for_event)(unsigned long,
-							efi_event_t *,
-							unsigned long *);
-		void *signal_event;
-		efi_status_t (__efiapi *close_event)(efi_event_t);
-		void *check_event;
-		void *install_protocol_interface;
-		void *reinstall_protocol_interface;
-		void *uninstall_protocol_interface;
-		efi_status_t (__efiapi *handle_protocol)(efi_handle_t,
-							 efi_guid_t *, void **);
-		void *__reserved;
-		void *register_protocol_notify;
-		efi_status_t (__efiapi *locate_handle)(int, efi_guid_t *,
-						       void *, unsigned long *,
-						       efi_handle_t *);
-		efi_status_t (__efiapi *locate_device_path)(efi_guid_t *,
-							    efi_device_path_protocol_t **,
-							    efi_handle_t *);
-		efi_status_t (__efiapi *install_configuration_table)(efi_guid_t *,
-								     void *);
-		void *load_image;
-		void *start_image;
-		efi_status_t (__efiapi *exit)(efi_handle_t,
-							 efi_status_t,
-							 unsigned long,
-							 efi_char16_t *);
-		void *unload_image;
-		efi_status_t (__efiapi *exit_boot_services)(efi_handle_t,
-							    unsigned long);
-		void *get_next_monotonic_count;
-		efi_status_t (__efiapi *stall)(unsigned long);
-		void *set_watchdog_timer;
-		void *connect_controller;
-		efi_status_t (__efiapi *disconnect_controller)(efi_handle_t,
-							       efi_handle_t,
-							       efi_handle_t);
-		void *open_protocol;
-		void *close_protocol;
-		void *open_protocol_information;
-		void *protocols_per_handle;
-		void *locate_handle_buffer;
-		efi_status_t (__efiapi *locate_protocol)(efi_guid_t *, void *,
-							 void **);
-		void *install_multiple_protocol_interfaces;
-		void *uninstall_multiple_protocol_interfaces;
-		void *calculate_crc32;
-		void *copy_mem;
-		void *set_mem;
-		void *create_event_ex;
-	};
-	struct {
-		efi_table_hdr_t hdr;
-		u32 raise_tpl;
-		u32 restore_tpl;
-		u32 allocate_pages;
-		u32 free_pages;
-		u32 get_memory_map;
-		u32 allocate_pool;
-		u32 free_pool;
-		u32 create_event;
-		u32 set_timer;
-		u32 wait_for_event;
-		u32 signal_event;
-		u32 close_event;
-		u32 check_event;
-		u32 install_protocol_interface;
-		u32 reinstall_protocol_interface;
-		u32 uninstall_protocol_interface;
-		u32 handle_protocol;
-		u32 __reserved;
-		u32 register_protocol_notify;
-		u32 locate_handle;
-		u32 locate_device_path;
-		u32 install_configuration_table;
-		u32 load_image;
-		u32 start_image;
-		u32 exit;
-		u32 unload_image;
-		u32 exit_boot_services;
-		u32 get_next_monotonic_count;
-		u32 stall;
-		u32 set_watchdog_timer;
-		u32 connect_controller;
-		u32 disconnect_controller;
-		u32 open_protocol;
-		u32 close_protocol;
-		u32 open_protocol_information;
-		u32 protocols_per_handle;
-		u32 locate_handle_buffer;
-		u32 locate_protocol;
-		u32 install_multiple_protocol_interfaces;
-		u32 uninstall_multiple_protocol_interfaces;
-		u32 calculate_crc32;
-		u32 copy_mem;
-		u32 set_mem;
-		u32 create_event_ex;
-	} mixed_mode;
-};
-
-typedef union efi_boot_services efi_boot_services_t;
+typedef struct {
+	efi_table_hdr_t hdr;
+	void *raise_tpl;
+	void *restore_tpl;
+	efi_status_t(__efiapi *allocate_pages)(int, int, unsigned long,
+					       efi_physical_addr_t *);
+	efi_status_t(__efiapi *free_pages)(efi_physical_addr_t,
+					   unsigned long);
+	efi_status_t(__efiapi *get_memory_map)(unsigned long *, void *,
+					       unsigned long *,
+					       unsigned long *, u32 *);
+	efi_status_t(__efiapi *allocate_pool)(int, unsigned long,
+					      void **);
+	efi_status_t(__efiapi *free_pool)(void *);
+	efi_status_t(__efiapi *create_event)(u32, unsigned long,
+					     efi_event_notify_t, void *,
+					     efi_event_t *);
+	efi_status_t(__efiapi *set_timer)(efi_event_t,
+					  EFI_TIMER_DELAY, u64);
+	efi_status_t(__efiapi *wait_for_event)(unsigned long,
+					       efi_event_t *,
+					       unsigned long *);
+	void *signal_event;
+	efi_status_t(__efiapi *close_event)(efi_event_t);
+	void *check_event;
+	void *install_protocol_interface;
+	void *reinstall_protocol_interface;
+	void *uninstall_protocol_interface;
+	efi_status_t(__efiapi *handle_protocol)(efi_handle_t,
+						efi_guid_t *, void **);
+	void *__reserved;
+	void *register_protocol_notify;
+	efi_status_t(__efiapi *locate_handle)(int, efi_guid_t *,
+					      void *, unsigned long *,
+					      efi_handle_t *);
+	efi_status_t(__efiapi *locate_device_path)(efi_guid_t *,
+						   efi_device_path_protocol_t **,
+						   efi_handle_t *);
+	efi_status_t(__efiapi *install_configuration_table)(efi_guid_t *,
+							    void *);
+	void *load_image;
+	void *start_image;
+	efi_status_t(__efiapi *exit)(efi_handle_t,
+				     efi_status_t,
+				     unsigned long,
+				     efi_char16_t *);
+	void *unload_image;
+	efi_status_t(__efiapi *exit_boot_services)(efi_handle_t,
+						   unsigned long);
+	void *get_next_monotonic_count;
+	efi_status_t(__efiapi *stall)(unsigned long);
+	void *set_watchdog_timer;
+	void *connect_controller;
+	efi_status_t(__efiapi *disconnect_controller)(efi_handle_t,
+						      efi_handle_t,
+						      efi_handle_t);
+	void *open_protocol;
+	void *close_protocol;
+	void *open_protocol_information;
+	void *protocols_per_handle;
+	void *locate_handle_buffer;
+	efi_status_t(__efiapi *locate_protocol)(efi_guid_t *, void *,
+						void **);
+	void *install_multiple_protocol_interfaces;
+	void *uninstall_multiple_protocol_interfaces;
+	void *calculate_crc32;
+	void *copy_mem;
+	void *set_mem;
+	void *create_event_ex;
+} efi_boot_services_t;
 
 /*
  * Types and defines for EFI ResetSystem
@@ -386,24 +327,6 @@ typedef union efi_boot_services efi_boot_services_t;
 #define EFI_RUNTIME_SERVICES_SIGNATURE ((u64)0x5652453544e5552ULL)
 #define EFI_RUNTIME_SERVICES_REVISION  0x00010000
 
-typedef struct {
-	efi_table_hdr_t hdr;
-	u32 get_time;
-	u32 set_time;
-	u32 get_wakeup_time;
-	u32 set_wakeup_time;
-	u32 set_virtual_address_map;
-	u32 convert_pointer;
-	u32 get_variable;
-	u32 get_next_variable;
-	u32 set_variable;
-	u32 get_next_high_mono_count;
-	u32 reset_system;
-	u32 update_capsule;
-	u32 query_capsule_caps;
-	u32 query_variable_info;
-} efi_runtime_services_32_t;
-
 typedef efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc);
 typedef efi_status_t efi_set_time_t (efi_time_t *tm);
 typedef efi_status_t efi_get_wakeup_time_t (efi_bool_t *enabled, efi_bool_t *pending,
@@ -438,25 +361,22 @@ typedef efi_status_t efi_query_variable_store_t(u32 attributes,
 						unsigned long size,
 						bool nonblocking);
 
-typedef union {
-	struct {
-		efi_table_hdr_t				hdr;
-		efi_get_time_t __efiapi			*get_time;
-		efi_set_time_t __efiapi			*set_time;
-		efi_get_wakeup_time_t __efiapi		*get_wakeup_time;
-		efi_set_wakeup_time_t __efiapi		*set_wakeup_time;
-		efi_set_virtual_address_map_t __efiapi	*set_virtual_address_map;
-		void					*convert_pointer;
-		efi_get_variable_t __efiapi		*get_variable;
-		efi_get_next_variable_t __efiapi	*get_next_variable;
-		efi_set_variable_t __efiapi		*set_variable;
-		efi_get_next_high_mono_count_t __efiapi	*get_next_high_mono_count;
-		efi_reset_system_t __efiapi		*reset_system;
-		efi_update_capsule_t __efiapi		*update_capsule;
-		efi_query_capsule_caps_t __efiapi	*query_capsule_caps;
-		efi_query_variable_info_t __efiapi	*query_variable_info;
-	};
-	efi_runtime_services_32_t mixed_mode;
+typedef struct {
+	efi_table_hdr_t				hdr;
+	efi_get_time_t __efiapi			*get_time;
+	efi_set_time_t __efiapi			*set_time;
+	efi_get_wakeup_time_t __efiapi		*get_wakeup_time;
+	efi_set_wakeup_time_t __efiapi		*set_wakeup_time;
+	efi_set_virtual_address_map_t __efiapi	*set_virtual_address_map;
+	void					*convert_pointer;
+	efi_get_variable_t __efiapi		*get_variable;
+	efi_get_next_variable_t __efiapi	*get_next_variable;
+	efi_set_variable_t __efiapi		*set_variable;
+	efi_get_next_high_mono_count_t __efiapi	*get_next_high_mono_count;
+	efi_reset_system_t __efiapi		*reset_system;
+	efi_update_capsule_t __efiapi		*update_capsule;
+	efi_query_capsule_caps_t __efiapi	*query_capsule_caps;
+	efi_query_variable_info_t __efiapi	*query_variable_info;
 } efi_runtime_services_t;
 
 #define EFI_SYSTEM_TABLE_SIGNATURE ((u64)0x5453595320494249ULL)
@@ -468,60 +388,23 @@ typedef union {
 #define EFI_1_10_SYSTEM_TABLE_REVISION  ((1 << 16) | (10))
 #define EFI_1_02_SYSTEM_TABLE_REVISION  ((1 << 16) | (02))
 
-typedef struct {
-	efi_table_hdr_t hdr;
-	u64 fw_vendor;	/* physical addr of CHAR16 vendor string */
-	u32 fw_revision;
-	u32 __pad1;
-	u64 con_in_handle;
-	u64 con_in;
-	u64 con_out_handle;
-	u64 con_out;
-	u64 stderr_handle;
-	u64 stderr;
-	u64 runtime;
-	u64 boottime;
-	u32 nr_tables;
-	u32 __pad2;
-	u64 tables;
-} efi_system_table_64_t;
+typedef union efi_simple_text_input_protocol efi_simple_text_input_protocol_t;
+typedef union efi_simple_text_output_protocol efi_simple_text_output_protocol_t;
 
 typedef struct {
 	efi_table_hdr_t hdr;
-	u32 fw_vendor;	/* physical addr of CHAR16 vendor string */
+	unsigned long fw_vendor;	/* physical addr of CHAR16 vendor string */
 	u32 fw_revision;
-	u32 con_in_handle;
-	u32 con_in;
-	u32 con_out_handle;
-	u32 con_out;
-	u32 stderr_handle;
-	u32 stderr;
-	u32 runtime;
-	u32 boottime;
-	u32 nr_tables;
-	u32 tables;
-} efi_system_table_32_t;
-
-typedef union efi_simple_text_input_protocol efi_simple_text_input_protocol_t;
-typedef union efi_simple_text_output_protocol efi_simple_text_output_protocol_t;
-
-typedef union {
-	struct {
-		efi_table_hdr_t hdr;
-		unsigned long fw_vendor;	/* physical addr of CHAR16 vendor string */
-		u32 fw_revision;
-		unsigned long con_in_handle;
-		efi_simple_text_input_protocol_t *con_in;
-		unsigned long con_out_handle;
-		efi_simple_text_output_protocol_t *con_out;
-		unsigned long stderr_handle;
-		unsigned long stderr;
-		efi_runtime_services_t *runtime;
-		efi_boot_services_t *boottime;
-		unsigned long nr_tables;
-		unsigned long tables;
-	};
-	efi_system_table_32_t mixed_mode;
+	unsigned long con_in_handle;
+	efi_simple_text_input_protocol_t *con_in;
+	unsigned long con_out_handle;
+	efi_simple_text_output_protocol_t *con_out;
+	unsigned long stderr_handle;
+	unsigned long stderr;
+	efi_runtime_services_t *runtime;
+	efi_boot_services_t *boottime;
+	unsigned long nr_tables;
+	unsigned long tables;
 } efi_system_table_t;
 
 struct efi_boot_memmap {
-- 
2.33.0

