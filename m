Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCD758E95F
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 11:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbiHJJOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 05:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiHJJOc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 05:14:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B81986C33
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 02:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660122871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BrnJHJ9Mo9d6LF8fLd160jO7vgau2DqXTrpWN+Q+1lI=;
        b=fEOMkGq9VR5Q0JDvQ25ZAOrpjabucKXfCyKZ9SRz6Zq13XSbtHELY5caCnfrO1inuDwbB2
        j8mN0d3lBNKucoEikHsjG1yFJDkQimsvlcSRVrdcf66n5DWYRIdIMIKX78sxNJWHqUzk0T
        dWEcXpFyUVbfUGmRU0myWKss1yZQj3U=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-QQksA9UqPEm9wvY3bLpEqw-1; Wed, 10 Aug 2022 05:14:27 -0400
X-MC-Unique: QQksA9UqPEm9wvY3bLpEqw-1
Received: by mail-ed1-f69.google.com with SMTP id w17-20020a056402269100b0043da2189b71so8683378edd.6
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 02:14:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=BrnJHJ9Mo9d6LF8fLd160jO7vgau2DqXTrpWN+Q+1lI=;
        b=gOPS/CS0X2F/g86R1NlCOu9bGxDzW/L4l1K42xMVI8Y2kVLDSpALWuh+2aeAgAzC0A
         AxYulYuE3XPb8nK4cwUcH5uFSg76R4WHiNYZhHRGzFE42IjcCvgn+1BKUJMJivi+nDPY
         8LajOygLzN0Ts+C988XoulhJkRsJte8dCFtndxST82bSuKTpGVWdaLSGelIaAae/N2++
         E98Fh6gnOiEIxYvuwRIQIAE6BYkmswC8AqtPlHiwjTW2zUmYZ5sx2jW+ElLt36S8uhF1
         GiGUh7bSrEoHGSnARy67L6V3ylv6PkxxgeoECqEPpLk9xVCH271604tvOKlNw/88+HSc
         nMXw==
X-Gm-Message-State: ACgBeo0IPPEjxMKPhnv4QT1SrEpBnyewS5jBuyeCKvGETx38Uq4tddf1
        PsVWrhMxof73iNrg3NPtKXpbse0SFyyBEkb2Y84JeboImc9a3Jt2FzVgGm7IvVS+Orhp5aMGhWZ
        QrskNBBtHAWNi
X-Received: by 2002:a05:6402:1cc4:b0:440:5af8:41c9 with SMTP id ds4-20020a0564021cc400b004405af841c9mr17458845edb.339.1660122865384;
        Wed, 10 Aug 2022 02:14:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4bQLwz0ay5kkw96DxJDx6+n/9y/Y6jEQ5yxdYJMMBH3d4Jv3191+PBY5JzY9jgLVspgmOkjg==
X-Received: by 2002:a05:6402:1cc4:b0:440:5af8:41c9 with SMTP id ds4-20020a0564021cc400b004405af841c9mr17458830edb.339.1660122865199;
        Wed, 10 Aug 2022 02:14:25 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id r17-20020a17090609d100b0073145afd156sm162913eje.80.2022.08.10.02.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 02:14:24 -0700 (PDT)
Message-ID: <bb97efaf-4f58-c192-a489-e71ebbebce8c@redhat.com>
Date:   Wed, 10 Aug 2022 11:14:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Gavin Shan <gshan@redhat.com>
Cc:     Florian Weimer <fweimer@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org,
        oliver upton <oliver.upton@linux.dev>,
        andrew jones <andrew.jones@linux.dev>, seanjc@google.com,
        yihyu@redhat.com, shan gavin <shan.gavin@gmail.com>
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-2-gshan@redhat.com>
 <8735e6ncxw.fsf@oldenburg.str.redhat.com>
 <7844e3fa-e49e-de75-e424-e82d3a023dd6@redhat.com>
 <87o7wtnay6.fsf@oldenburg.str.redhat.com>
 <616d4de6-81f6-9d14-4e57-4a79fec45690@redhat.com>
 <797306043.114963.1660047714774.JavaMail.zimbra@efficios.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
In-Reply-To: <797306043.114963.1660047714774.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/9/22 14:21, Mathieu Desnoyers wrote:
>> For kvm/selftests, there are 3 architectures involved actually. So we
>> just need consider 4 cases: aarch64, x86, s390 and other. For other
>> case, we just use __builtin_thread_pointer() to maintain code's
>> integrity, but it's not called at all.
>>
>> I think kvm/selftest is always relying on glibc if I'm correct.
> All those are handled in the rseq selftests and in librseq. Why duplicate all that logic again?

Yeah, rseq_test should reuse librseq code.  The simplest way,
if slightly hackish, is to do something like

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 690b499c3471..6c192b0ec304 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -37,6 +37,7 @@ ifeq ($(ARCH),riscv)
  	UNAME_M := riscv
  endif
  
  LIBKVM += lib/assert.c
  LIBKVM += lib/elf.c
  LIBKVM += lib/guest_modes.c
@@ -198,7 +199,7 @@ endif
  CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
  	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
  	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
-	-I$(<D) -Iinclude/$(UNAME_M) -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
+	-I$(<D) -Iinclude/$(UNAME_M) -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES) -I../rseq
  
  no-pie-option := $(call try-run, echo 'int main() { return 0; }' | \
          $(CC) -Werror -no-pie -x c - -o "$$TMP", -no-pie)


and just #include "../rseq/rseq.c" in rseq_test.c.

Thanks,

Paolo

