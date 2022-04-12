Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493134FCBDD
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 03:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238991AbiDLB11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 21:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiDLB10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 21:27:26 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CF51A814
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 18:25:10 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id z16so16119940pfh.3
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 18:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qLkG0TlTkLtkn7/YDi2Nz0t09sVP5EaquDCxlZc7iVE=;
        b=qtFpfnhXLPAMO82Aps6yxmMJSr67hbNkkZXmdGS/KL8Y8KczxORah8E8wSDUtYFOZd
         IAJGjfeySrEbHSuM15fwAqUB02UhRrzMTbEZ0JNup0o0cPQ5whA0/l6r5uJlqLUMJYG1
         su6lWltTtv6nf/kmK6rT0z4bg8JrODCn8066McpWbQnVVMOopX5xV0KjOoFOSbd9aXMS
         2TFmU4KP31uZqaluiZ2MYgg48UrBYipcv5WPua4VJF3j3wu4AERnN4paFhyAdATlZGCz
         ypoFhTAwNJELuKspm1q/0GWfl/+jIDq8bJ9Dq4YDo3SJhJno/7NT5xCM1JTM62op7pDa
         UG7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qLkG0TlTkLtkn7/YDi2Nz0t09sVP5EaquDCxlZc7iVE=;
        b=e+ZAj8FWFbvo3hhmpscWNfa9ZKjqNULHS5nbypmkRA8CEWMv5pmAsfIw6sZiLdLzGW
         AG+SatqJt3PAcxkK8/V+XXKvBP+iDx89upwVpd9lYkolsxqFYj43OWYK6i/NbtyfAZ46
         qaxgxrrgYyYt5sRhzsTVOb5a6J5Ba6RfjOM72dYvKbR3ipoGm+yCcdUhqcI+o5H3+tgg
         GqnF7MnGIJdz2uus7tTasfZbl41Jw8ifg8Moi/c6J/qzbB8I3vbwHiG9eEgRGHSnpe6J
         8ThkrsHBZAUJ5bqA/qYiqCXTHy5aFiqk/F7sE8nJnoLuGDaN8C7VQuMFrvKUgM3pObWz
         lzQw==
X-Gm-Message-State: AOAM531Dibz2Dvk4HidRvFzJuLi0KS5loiEhFdILd7kkPeYaSYfJye1l
        Y0zKwFGt6Vn4XujGOGhtwavhLAaNMA3UI5Qh
X-Google-Smtp-Source: ABdhPJx7pt1bxVJmlx1dwnHe4fO6l3jJivv3igbrMW3nFY6RPvJVoTAnmhVy0/cSdpzFZAh2BeRonA==
X-Received: by 2002:a63:1543:0:b0:39d:9729:1992 with SMTP id 3-20020a631543000000b0039d97291992mr536239pgv.155.1649726709466;
        Mon, 11 Apr 2022 18:25:09 -0700 (PDT)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id e14-20020a62aa0e000000b00505c05545f8sm4916521pff.108.2022.04.11.18.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 18:25:08 -0700 (PDT)
Date:   Tue, 12 Apr 2022 01:25:05 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v4 04/10] KVM: selftests: Read binary stat data in lib
Message-ID: <YlTU8YXmoLED1VHC@google.com>
References: <20220411211015.3091615-1-bgardon@google.com>
 <20220411211015.3091615-5-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411211015.3091615-5-bgardon@google.com>
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

On Mon, Apr 11, 2022, Ben Gardon wrote:
> Move the code to read the binary stats data to the KVM selftests
> library. It will be re-used by other tests to check KVM behavior.
> 
> No functional change intended.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  3 +++
>  .../selftests/kvm/kvm_binary_stats_test.c     | 20 +++++-------------
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++++++
>  3 files changed, 29 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index c5f34551ff76..b2684cfc2cb1 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -405,6 +405,9 @@ struct kvm_stats_desc *alloc_vm_stats_desc(int stats_fd,
>  					  struct kvm_stats_header *header);
>  void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
>  			struct kvm_stats_desc *stats_desc);
> +int read_stat_data(int stats_fd, struct kvm_stats_header *header,
> +		   struct kvm_stats_desc *desc, uint64_t *data,
> +		   ssize_t max_elements);
>  
>  uint32_t guest_get_vcpuid(void);
>  
> diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> index e4795bad7db6..97b180249ba0 100644
> --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> @@ -20,6 +20,8 @@
>  #include "asm/kvm.h"
>  #include "linux/kvm.h"
>  
> +#define STAT_MAX_ELEMENTS 1000
> +
>  static void stats_test(int stats_fd)
>  {
>  	ssize_t ret;
> @@ -29,7 +31,7 @@ static void stats_test(int stats_fd)
>  	struct kvm_stats_header header;
>  	char *id;
>  	struct kvm_stats_desc *stats_desc;
> -	u64 *stats_data;
> +	u64 stats_data[STAT_MAX_ELEMENTS];
>  	struct kvm_stats_desc *pdesc;
>  
>  	/* Read kvm stats header */
> @@ -130,25 +132,13 @@ static void stats_test(int stats_fd)
>  			pdesc->offset, pdesc->name);
>  	}
>  
> -	/* Allocate memory for stats data */
> -	stats_data = malloc(size_data);
> -	TEST_ASSERT(stats_data, "Allocate memory for stats data");
> -	/* Read kvm stats data as a bulk */
> -	ret = pread(stats_fd, stats_data, size_data, header.data_offset);
> -	TEST_ASSERT(ret == size_data, "Read KVM stats data");
>  	/* Read kvm stats data one by one */
> -	size_data = 0;
>  	for (i = 0; i < header.num_desc; ++i) {
>  		pdesc = (void *)stats_desc + i * size_desc;
> -		ret = pread(stats_fd, stats_data,
> -				pdesc->size * sizeof(*stats_data),
> -				header.data_offset + size_data);
> -		TEST_ASSERT(ret == pdesc->size * sizeof(*stats_data),
> -				"Read data of KVM stats: %s", pdesc->name);
> -		size_data += pdesc->size * sizeof(*stats_data);
> +		read_stat_data(stats_fd, &header, pdesc, stats_data,
> +			       ARRAY_SIZE(stats_data));
>  	}
>  
> -	free(stats_data);
>  	free(stats_desc);
>  	free(id);
>  }
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index e3ae26fbef03..64e2085f1129 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2593,3 +2593,24 @@ void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
>  	TEST_ASSERT(ret == stats_descs_size(header),
>  		    "Read KVM stats descriptors");
>  }
> +
> +int read_stat_data(int stats_fd, struct kvm_stats_header *header,
> +		   struct kvm_stats_desc *desc, uint64_t *data,
> +		   ssize_t max_elements)
> +{
> +	ssize_t ret;
> +
> +	TEST_ASSERT(desc->size <= max_elements,
> +		    "Max data elements should be at least as large as stat data");
> +
> +	ret = pread(stats_fd, data, desc->size * sizeof(*data),
> +		    header->data_offset + desc->offset);

hmm, by checking the comments in kvm.h, I cannot infer desc->offset
should be added with header->data_offset. So, could you add the
following commit into your series. I feel that we need to improve
readability a little bit. Existing comments for kvm_stats_desc is not
quite helpful for users.

From: Mingwei Zhang <mizhang@google.com>
Date: Tue, 12 Apr 2022 01:09:10 +0000
Subject: [PATCH] KVM: stats: improve readability of kvm_stats_header and
 kvm_stats_desc

Some comments on these data structures are not quite helpful from user
perspective. For instance, kvm_stats_header->name_size was shared across
all stats. This might be a little bit counter-intuitive, since each stat
should have a different name length. So it has to be the maximum length of
the stats string. We cannot infer that by just reading the comments without
going through the implementation. In addition, kvm_stat_desc->offset is a
relative offset base on kvm_stats_header->data_offset. It is better to call
it out clearly in comments.

Update the comments of the fields in these two data structures.

Cc: Jing Zhang <zhangjingos@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 include/uapi/linux/kvm.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5c0d7c77e9bd..986728b5b3fb 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1987,7 +1987,7 @@ struct kvm_dirty_gfn {
 /**
  * struct kvm_stats_header - Header of per vm/vcpu binary statistics data.
  * @flags: Some extra information for header, always 0 for now.
- * @name_size: The size in bytes of the memory which contains statistics
+ * @name_size: The maximum size in bytes of the memory which contains statistics
  *             name string including trailing '\0'. The memory is allocated
  *             at the send of statistics descriptor.
  * @num_desc: The number of statistics the vm or vcpu has.
@@ -2042,7 +2042,8 @@ struct kvm_stats_header {
  * @size: The number of data items for this stats.
  *        Every data item is of type __u64.
  * @offset: The offset of the stats to the start of stat structure in
- *          structure kvm or kvm_vcpu.
+ *          structure kvm or kvm_vcpu. When using it, add its value with
+ *          kvm_stats_header->data_offset.
  * @bucket_size: A parameter value used for histogram stats. It is only used
  *		for linear histogram stats, specifying the size of the bucket;
  * @name: The name string for the stats. Its size is indicated by the

base-commit: ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e
--
2.35.1.1178.g4f1659d476-goog
> +
> +	/* ret from pread is in bytes. */
> +	ret = ret / sizeof(*data);
> +
> +	TEST_ASSERT(ret == desc->size,
> +		    "Read data of KVM stats: %s", desc->name);
> +
> +	return ret;
> +}
> -- 
> 2.35.1.1178.g4f1659d476-goog
> 
