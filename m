Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26049453B16
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 21:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhKPUnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 15:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhKPUny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 15:43:54 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A14C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:40:57 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso525172pjb.0
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NWDKpsQFk5mN1jQnrTsnd6C8/vgl4oVD+4bLDzSVTA4=;
        b=BUZriuUCZaEqLELZx01yp5T528kyEBFfOP+m/pnCa/gr0Nr+jVhJmBN4gksVKnllpa
         rIGvPF/5jY2pXHksacZGehBOvYhZafRVp2bhwGcA1Ir66VCruLifsvFlWptWo0KsBcVe
         QbUC/24ylEw6N2YOmxh9zlieOOj0pwu766x8L+LKoSiOBnAgTf4QmctxfssXX6MhgTN6
         hVWL1Ds5h0TGIYJyFZ7M2PbhxTKUI+42G2Y/0nbsXRehvSiMDoe0+IldRAaBqgUJiMn3
         O0tqP5YaZ3O0yCyz7goVHAdNOEYaKn8bwuyS5rS2T6PBJ52LFJSwiRcX+8yEzqfCUzsA
         9xkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NWDKpsQFk5mN1jQnrTsnd6C8/vgl4oVD+4bLDzSVTA4=;
        b=enZVrE75DEujYhnWwXvkYe1MnttZgDiUaJDJ9YyjVqcqfQI8DFvxgsT3vCT5i1FOQF
         TtSL4swbq+z1LGemWvjli/V+OoGeEdFUrG8GLyEOmK0clQ2HzjYgARU4LcsU7wVsu0hn
         br/uQFFQVZ87eOFMUOfGjTmRykrhXmCz0ZlI10XQCWIuqiAv91cg8lOkGgO6uNRqzkU+
         bqAcx/TpBUfidxSB9luQomjJXG/GTAvDFvvtJAOr1jpOzo44FyRcyESszqOoS5U358Xn
         X3YAHap3+YXZ0Umz6kx7V8ykvlrruqjxxG/WohXym+qUTDEoRL8REg86bikMokIEjglU
         CZGg==
X-Gm-Message-State: AOAM533Mo0L4bRUJZYsZjAsHct73MTVXG6n01UM2tEjRbps0O53cs1H3
        evkfuMvfTDUwYMF9Vo6F5UVdPpI9SXLz1g==
X-Google-Smtp-Source: ABdhPJy6X9K6G80bB94GZKjfhaB/vdpu+jgjhSeT0EWqHRb2f71kUduH2YIVKw9vcqtPI7kjk4zPgw==
X-Received: by 2002:a17:90a:e7d1:: with SMTP id kb17mr2368408pjb.124.1637095256668;
        Tue, 16 Nov 2021 12:40:56 -0800 (PST)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id lp12sm3652359pjb.24.2021.11.16.12.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 12:40:56 -0800 (PST)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v2 01/10] x86 UEFI: Remove mixed_mode
Date:   Tue, 16 Nov 2021 12:40:44 -0800
Message-Id: <20211116204053.220523-2-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116204053.220523-1-zxwang42@gmail.com>
References: <20211116204053.220523-1-zxwang42@gmail.com>
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

