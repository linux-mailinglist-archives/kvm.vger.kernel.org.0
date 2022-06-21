Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C31B5537D7
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351855AbiFUQdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 12:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350998AbiFUQdq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 12:33:46 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF9C140A1
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:33:45 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id t21so7315417pfq.1
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Myn0KFUXqsoCOKPE8KzckaDpi4y+6GAGpS7V0lFaU88=;
        b=UiDn1O8MMy9nsfvnbzdbYZfGAO7IM7xZnM/FIXO3rzBaNGa0wQlyTPtBOXqSECmfrN
         alYqmZPtHq5FNDWyYmTX2nFgGCqgwPFW7pi3u6VUjZGdCOIq9jD/hGDXSejCgDFPwDfp
         x2xhj8IqBsFep+Hrd2Hj96C8wnHWJ4SyWWJiz7Cj8RxwGDsnM1Y/yBDCVEIcMfJDvK+9
         tmwnOslHHgKRKtehH1wKIhQSVFyCGysQl5/sTq/miQNV5t+6lCg4625fflU9q8qHSOIx
         NdODtJGxaGZZpQQV0KaiM3FTprr9yZ0TPDBhrh5cJAuYao/Ebfv9y7dt/js86fomEA7I
         RPVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Myn0KFUXqsoCOKPE8KzckaDpi4y+6GAGpS7V0lFaU88=;
        b=j8smCdjtRWCfCWGhbez5dcisdfzm8FSoYynoC4P1bODL9/Cx5kUqXBIXd5NK6A7Crx
         itbau/Q0QvWwgNx2fDjrh2BrP7eNON/vzD1lOogQFnUNViDfyihHoClupWeii/738xbr
         Qw7wk8Er6oK9cb+dUVJz+wb3Fm8MceCWIM8u93DI2T8i4hCRLh7LGDRayz/uqpaSmk8u
         FyU4GZlqmPeN8eXFeNYsn8K5G6CNylk+QhjohYGZ3qBUz+NHyDsXGTk+3YKlchbwcYTz
         gVlh2XuDs2eWI6CP6Fr9JJ4tuHAlj6+9VO5JFs5SBtEW8SuSEG0pzlTvaA/56SV+3R98
         hebA==
X-Gm-Message-State: AJIora+w6W9OJAUo62bIn5k9Inr9F5ywFGAGctYcLsDui9527MnyrCey
        1vIJfAMpzgMavbzFHX2K+q0Xn3Y0AC3Vtg==
X-Google-Smtp-Source: AGRyM1v+cvaVAtFdxH8NoNNSJjJK8iMnzyq+lyn+1G2u/WslHhAAzkfzed0zkGGAnv8uDeCvETJaGw==
X-Received: by 2002:a63:b256:0:b0:40c:c88a:47b2 with SMTP id t22-20020a63b256000000b0040cc88a47b2mr8180053pgo.190.1655829225046;
        Tue, 21 Jun 2022 09:33:45 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id o1-20020a629a01000000b0051bada81bc7sm11495763pfe.161.2022.06.21.09.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 09:33:44 -0700 (PDT)
Date:   Tue, 21 Jun 2022 09:33:41 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 11/23] lib/efi: Add support for getting
 the cmdline
Message-ID: <YrHy5TLGLHkAYfzy@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-12-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-12-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:55:53PM +0100, Nikos Nikoleris wrote:
> This change adds support for discovering the command line arguments,
> as a string. Then, we parse this string to populate __argc and __argv
> for EFI tests.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/linux/efi.h |  39 +++++++++++++++
>  lib/stdlib.h    |   1 +
>  lib/efi.c       | 123 ++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/string.c    |   2 +-
>  4 files changed, 164 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/linux/efi.h b/lib/linux/efi.h
> index 455625a..e3aba1d 100644
> --- a/lib/linux/efi.h
> +++ b/lib/linux/efi.h
> @@ -60,6 +60,10 @@ typedef guid_t efi_guid_t;
>  
>  #define ACPI_TABLE_GUID EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
>  
> +#define LOADED_IMAGE_PROTOCOL_GUID EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
> +
> +#define efi_table_attr(inst, attr) (inst->attr)
> +
>  typedef struct {
>  	efi_guid_t guid;
>  	void *table;
> @@ -416,6 +420,41 @@ struct efi_boot_memmap {
>  	unsigned long           *buff_size;
>  };
>  
> +#define __aligned_u64 u64 __attribute__((aligned(8)))
> +
> +typedef union {
> +	struct {
> +		u32			revision;
> +		efi_handle_t		parent_handle;
> +		efi_system_table_t	*system_table;
> +		efi_handle_t		device_handle;
> +		void			*file_path;
> +		void			*reserved;
> +		u32			load_options_size;
> +		void			*load_options;
> +		void			*image_base;
> +		__aligned_u64		image_size;
> +		unsigned int		image_code_type;
> +		unsigned int		image_data_type;
> +		efi_status_t		(__efiapi *unload)(efi_handle_t image_handle);
> +	};
> +	struct {
> +		u32		revision;
> +		u32		parent_handle;
> +		u32		system_table;
> +		u32		device_handle;
> +		u32		file_path;
> +		u32		reserved;
> +		u32		load_options_size;
> +		u32		load_options;
> +		u32		image_base;
> +		__aligned_u64	image_size;
> +		u32		image_code_type;
> +		u32		image_data_type;
> +		u32		unload;
> +	} mixed_mode;
> +} efi_loaded_image_t;

Is the 32-bit mode used (in later commits)? Why not reuse
efi_loaded_image_64_t only and make sure it's the one expected.

> +
>  #define efi_bs_call(func, ...) efi_system_table->boottime->func(__VA_ARGS__)
>  #define efi_rs_call(func, ...) efi_system_table->runtime->func(__VA_ARGS__)
>  
> diff --git a/lib/stdlib.h b/lib/stdlib.h
> index 28496d7..2c524d7 100644
> --- a/lib/stdlib.h
> +++ b/lib/stdlib.h
> @@ -7,6 +7,7 @@
>  #ifndef _STDLIB_H_
>  #define _STDLIB_H_
>  
> +int isspace(int c);
>  long int strtol(const char *nptr, char **endptr, int base);
>  unsigned long int strtoul(const char *nptr, char **endptr, int base);
>  long long int strtoll(const char *nptr, char **endptr, int base);
> diff --git a/lib/efi.c b/lib/efi.c
> index 64cc978..5341942 100644
> --- a/lib/efi.c
> +++ b/lib/efi.c
> @@ -8,6 +8,7 @@
>   */
>  
>  #include "efi.h"
> +#include <stdlib.h>
>  #include <libcflat.h>
>  #include <asm/setup.h>
>  
> @@ -96,6 +97,97 @@ static void efi_exit(efi_status_t code)
>  	efi_rs_call(reset_system, EFI_RESET_SHUTDOWN, code, 0, NULL);
>  }
>  
> +static void efi_cmdline_to_argv(char *cmdline_ptr)
> +{
> +	char *c = cmdline_ptr;
> +	bool narg = true;
> +	while (*c) {
> +		if (isspace(*c)) {
> +			*c = '\0';
> +			narg = true;
> +		} else if (narg) {
> +			__argv[__argc++] = c;
> +			narg = false;
> +		}
> +		c++;
> +	}
> +}
> +
> +static char *efi_convert_cmdline(efi_loaded_image_t *image, int *cmd_line_len)

Mention that this was adapted from drivers/firmware/efi/libstub/efi-stub.c.

> +{
> +	const u16 *s2;
> +	unsigned long cmdline_addr = 0;
> +	int options_chars = efi_table_attr(image, load_options_size) / 2;
> +	const u16 *options = efi_table_attr(image, load_options);
> +	int options_bytes = 0, safe_options_bytes = 0;  /* UTF-8 bytes */
> +	bool in_quote = false;
> +	efi_status_t status;
> +	const int COMMAND_LINE_SIZE = 2048;
> +
> +	if (options) {
> +		s2 = options;
> +		while (options_bytes < COMMAND_LINE_SIZE && options_chars--) {
> +			u16 c = *s2++;
> +
> +			if (c < 0x80) {
> +				if (c == L'\0' || c == L'\n')
> +					break;
> +				if (c == L'"')
> +					in_quote = !in_quote;
> +				else if (!in_quote && isspace((char)c))
> +					safe_options_bytes = options_bytes;
> +
> +				options_bytes++;
> +				continue;
> +			}
> +
> +			/*
> +			 * Get the number of UTF-8 bytes corresponding to a
> +			 * UTF-16 character.
> +			 * The first part handles everything in the BMP.
> +			 */
> +			options_bytes += 2 + (c >= 0x800);
> +			/*
> +			 * Add one more byte for valid surrogate pairs. Invalid
> +			 * surrogates will be replaced with 0xfffd and take up
> +			 * only 3 bytes.
> +			 */
> +			if ((c & 0xfc00) == 0xd800) {
> +				/*
> +				 * If the very last word is a high surrogate,
> +				 * we must ignore it since we can't access the
> +				 * low surrogate.
> +				 */
> +				if (!options_chars) {
> +					options_bytes -= 3;
> +				} else if ((*s2 & 0xfc00) == 0xdc00) {
> +					options_bytes++;
> +					options_chars--;
> +					s2++;
> +				}
> +			}
> +		}
> +		if (options_bytes >= COMMAND_LINE_SIZE) {
> +			options_bytes = safe_options_bytes;
> +			printf("Command line is too long: truncated to %d bytes\n",
> +			       options_bytes);
> +		}
> +        }
> +
> +	options_bytes++;        /* NUL termination */
> +
> +	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, options_bytes,
> +			     (void **)&cmdline_addr);
> +	if (status != EFI_SUCCESS)
> +		return NULL;
> +
> +	snprintf((char *)cmdline_addr, options_bytes, "%.*ls",
> +		 options_bytes - 1, options);
> +
> +	*cmd_line_len = options_bytes;
> +	return (char *)cmdline_addr;
> +}
> +
>  efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>  {
>  	int ret;
> @@ -109,6 +201,37 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>  	unsigned long map_size = 0, desc_size = 0, key = 0, buff_size = 0;
>  	u32 desc_ver;
>  
> +	/* Helper variables needed to get the cmdline */
> +	efi_loaded_image_t *image;
> +	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
> +	char *cmdline_ptr = NULL;
> +	int cmdline_size = 0;
> +
> +	/*
> +	 * Get a handle to the loaded image protocol.  This is used to get
> +	 * information about the running image, such as size and the command
> +	 * line.
> +	 */
> +	status = efi_bs_call(handle_protocol, handle, &loaded_image_proto,
> +			     (void *)&image);
> +	if (status != EFI_SUCCESS) {
> +		printf("Failed to get loaded image protocol\n");
> +		goto efi_main_error;
> +	}
> +
> +	/*
> +	 * Get the command line from EFI, using the LOADED_IMAGE
> +	 * protocol. We are going to copy the command line into the
> +	 * device tree, so this can be allocated anywhere.

Does the "device tree" comment still make sense?

> +	 */
> +	cmdline_ptr = efi_convert_cmdline(image, &cmdline_size);
> +	if (!cmdline_ptr) {
> +		printf("getting command line via LOADED_IMAGE_PROTOCOL\n");
> +		status = EFI_OUT_OF_RESOURCES;
> +		goto efi_main_error;
> +	}
> +	efi_cmdline_to_argv(cmdline_ptr);
> +
>  	/* Set up efi_bootinfo */
>  	efi_bootinfo.mem_map.map = &map;
>  	efi_bootinfo.mem_map.map_size = &map_size;
> diff --git a/lib/string.c b/lib/string.c
> index 27106da..b191ab1 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -163,7 +163,7 @@ void *memchr(const void *s, int c, size_t n)
>      return NULL;
>  }
>  
> -static int isspace(int c)
> +int isspace(int c)
>  {
>      return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\v' || c == '\f';
>  }
> -- 
> 2.25.1
> 
