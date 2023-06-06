Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076FB7233F2
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 02:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjFFAFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 20:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjFFAFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 20:05:50 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40E1F4
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 17:05:48 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53f8167fb04so1729044a12.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 17:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686009948; x=1688601948;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OBz+HSN+31dRUaUWc+qcZ0cAR/ersHwA9yY+xFkntfk=;
        b=OsA8PBPgRSnXxhFOgZ9TVVBeNa8PzDyy2Gw1cjQh6e9HDV4nvfkK5czOONlibxXgi4
         ZM7HOo0yqNdzCvSTd/emfyHlhnooFOJU02TjYF7f9FNRe1sSi+1cO+fQ+Qx7AJQR8PHF
         sRrfF6790YFXfJUHzzhEWFxPIXoNCwO3pmOnzjJdNFlTBXcRb2RrnxJLReeDk+j3jiOQ
         9+uE25L0xxDhRD8Wj6gghWll0ZmoKQ5MS9KtbshbMw5EC393zLQLvhwzo5tyqES5i++X
         V8rmLIEuSPcvQVgzMPVCSBgOkL+ER4xV05Ezj4JYDNZKhZd3KhoS3RVaozk8Bj/BkL9x
         pjew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686009948; x=1688601948;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OBz+HSN+31dRUaUWc+qcZ0cAR/ersHwA9yY+xFkntfk=;
        b=bh53QAy1J/0VlK5GehATwkbZDjOCt4ocdoLtwxMnk0mkWMd79lfn4fz/M4nk/asWgu
         auHeCqzHqTNYjON9w5rRctfKEtBrzZ7Ly/cxEHZWwPbu/LlxHue61M21Ma/XI0WFQC5q
         vVCT557aSo/w8gcdIc4woENRX3uhcy8He/zyMZZhydCKP3HV/tjWqUCpDnpo0zbjPa6W
         8AkyuhfwyJCeKLz4kBPaC749tmw4pwdVbgsRElnzT0rkAp7riYAv7/lzcotoKhphP1sF
         hHrpHUqNTAKfX2tOeN9H2lYBOOYKGSY3CWKKkMECIG97rdVA0cPrpUlBeYm0OOSicgJl
         75eQ==
X-Gm-Message-State: AC+VfDz3Ugj1VbAgrY8+OQsmWrXSuxCKUsEcqO+I+ijMc3aToXl2ocD0
        NJlPai+zFB3EE6Laafu10/zTYm+DDk4=
X-Google-Smtp-Source: ACHHUZ4k9WS98RnQldhf6miXA7dm7dPq2Ub5wDc7Cd6pQABLsDM5PeFs7xfkzCgYj6CQL/TQhKN4Vycd1nw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4b1c:0:b0:52c:9e55:61ee with SMTP id
 y28-20020a634b1c000000b0052c9e5561eemr6935pga.3.1686009948386; Mon, 05 Jun
 2023 17:05:48 -0700 (PDT)
Date:   Mon, 5 Jun 2023 17:05:46 -0700
In-Reply-To: <20230424225854.4023978-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230424225854.4023978-1-aaronlewis@google.com> <20230424225854.4023978-3-aaronlewis@google.com>
Message-ID: <ZH54WgNDADIhX2wx@google.com>
Subject: Re: [PATCH v2 2/6] KVM: selftests: Add kvm_snprintf() to KVM selftests
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023, Aaron Lewis wrote:
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index a6e9f215ce70..45cb0dd41412 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -186,4 +186,7 @@ static inline uint32_t atoi_non_negative(const char *name, const char *num_str)
>  	return num;
>  }
>  
> +int kvm_vsnprintf(char *buf, int n, const char *fmt, va_list args);
> +int kvm_snprintf(char *buf, int n, const char *fmt, ...);
> +
>  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_sprintf.c b/tools/testing/selftests/kvm/lib/kvm_sprintf.c
> new file mode 100644
> index 000000000000..db369e00a6fc
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/kvm_sprintf.c
> @@ -0,0 +1,313 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include "test_util.h"
> +
> +#define ASSIGN_AND_INC_SAFE(str, end, v) \
> +({					 \
> +	if (str < end)			 \

This should assert instead of hiding the error and forcing the caller to detect
the problem, which may or may not actually happen.  The easiest thing is to just
thie guest only, e.g. name the helpers guest_*snprintf() and then do

#define APPEND_BUFFER_SAFE(str, end, v)	\
do {					\
	GUEST_ASSERT(str < end);	\
	*str++ = (v);			\
} while (0)

I doubt there will be a use case for using the custom snprintf in a helper that
is common to guest and host, and if someone does need/want that functionality,
they can add a global flag to track whether or not selftests is running guest or
host code.

And I would deliberately use GUEST_ASSERT() instead of a GUEST_UCALL_FAILED.
KVM carves out enough space for KVM_MAX_VCPUS concurrent/nested ucalls, so for
the vast majority of tests using GUEST_ASSERT() will succeed and be useful.  And
if some test exhausts the ucall pool, it'll end up with GUEST_UCALL_FAILED anyways.
