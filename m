Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF34539DA8
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 09:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350119AbiFAHDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 03:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241833AbiFAHDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 03:03:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C77F77CB67
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 00:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654067022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EqoFuRQUM7f+wDYyOiCvpUOo+az8/RZ1hy1ZC3zBV+s=;
        b=SRaGqjGZYUVOKsnvm8dV53EK4CJTEqbXTW6Wj9sXa9awDpZEgDZJ7tBt6naoOTBO0azyEf
        6kTMpMqRSTsaleFuB0LW8tNuMm70VwSUu0bvtGRAnhxfOW5cNZsCjxV6H7FjSZw/Fco22Y
        eyWuF8fXWPgGa7BE3j6H/G+6eaVeaiE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-gBE7FScBMW-H7LqOmlh90Q-1; Wed, 01 Jun 2022 03:03:41 -0400
X-MC-Unique: gBE7FScBMW-H7LqOmlh90Q-1
Received: by mail-wm1-f72.google.com with SMTP id bg7-20020a05600c3c8700b0039468585269so468554wmb.3
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 00:03:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=EqoFuRQUM7f+wDYyOiCvpUOo+az8/RZ1hy1ZC3zBV+s=;
        b=eu0Aw2ZUBFG2/DppIrDa9tuq+sy0ObQwM9zWp5mXIO4v61CgJAlqRix0uwnCVPKJ5j
         Fv2gV05CG7oac0CumnqCW0WKYX41OBpja4e5F6xETjTdSxi0G8j6osNz6jpzRYSzjStI
         WvqgW59d+96oJelK53Xls2vBsmwTOrgx0+9jEb336BpCEmmkq/36CqP1Mr7g4x81oH1o
         KQ5+ExdmsRhmEfoJui9Ox5TPIkgi4k2DZqVNwVYd/fNACEA8ibBvA7gIMVsVmQLbN0tQ
         XF7El2/AwHrOweQhrT4ty4G0pxQDqmqC+i5aJXBcbeMR6jBA3HTrLuaX6EOwk6adrrAj
         BBTQ==
X-Gm-Message-State: AOAM532UP9ljACNRZqQg9cZgF9s85VEUOnx4YrL6vKDiXPXMY9pSIihs
        XRsjTApc1s4/bGdClvu07HhFJNbaFIrOOnFfY97vv8tXI9n9S68K3cyqjNKIxtrDgD6tvWWG3H+
        1Ylhna24oe+Om
X-Received: by 2002:adf:fb0d:0:b0:20d:97e:17ce with SMTP id c13-20020adffb0d000000b0020d097e17cemr54839571wrr.585.1654067020224;
        Wed, 01 Jun 2022 00:03:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8alifl63LBJtH1A+P+0sgAmCXmt+kv4uQiD9rXrE3cK9kaSLkH80u8/vfWeumhMD0epMrVg==
X-Received: by 2002:adf:fb0d:0:b0:20d:97e:17ce with SMTP id c13-20020adffb0d000000b0020d097e17cemr54839550wrr.585.1654067019967;
        Wed, 01 Jun 2022 00:03:39 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id bg16-20020a05600c3c9000b0039763d41a48sm967035wmb.25.2022.06.01.00.03.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 00:03:39 -0700 (PDT)
Message-ID: <686aae9b-6877-7d7a-3fd4-cddb21642322@redhat.com>
Date:   Wed, 1 Jun 2022 09:03:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Dan Cross <cross@oxidecomputer.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220526071156.yemqpnwey42nw7ue@gator>
 <20220526173949.4851-1-cross@oxidecomputer.com>
 <20220526173949.4851-2-cross@oxidecomputer.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 1/2] kvm-unit-tests: invoke $LD explicitly in
In-Reply-To: <20220526173949.4851-2-cross@oxidecomputer.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/05/2022 19.39, Dan Cross wrote:
> Change x86/Makefile.common to invoke the linker directly instead
> of using the C compiler as a linker driver.
> 
> This supports building on illumos, allowing the user to use
> gold instead of the Solaris linker.  Tested on Linux and illumos.
> 
> Signed-off-by: Dan Cross <cross@oxidecomputer.com>
> ---
>   x86/Makefile.common | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index b903988..0a0f7b9 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -62,7 +62,7 @@ else
>   .PRECIOUS: %.elf %.o
>   
>   %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
> -	$(CC) $(CFLAGS) -nostdlib -o $@ -Wl,-T,$(SRCDIR)/x86/flat.lds \
> +	$(LD) -T $(SRCDIR)/x86/flat.lds -nostdlib -o $@ \
>   		$(filter %.o, $^) $(FLATLIBS)
>   	@chmod a-x $@


  Hi,

something seems to be missing here - this is failing our 32-bit
CI job:

  https://gitlab.com/thuth/kvm-unit-tests/-/jobs/2531237708

ld -T /builds/thuth/kvm-unit-tests/x86/flat.lds -nostdlib -o x86/taskswitch2.elf \
	x86/taskswitch2.o x86/cstart.o lib/libcflat.a
ld: i386 architecture of input file `x86/taskswitch.o' is incompatible with i386:x86-64 output
ld: i386 architecture of input file `x86/cstart.o' is incompatible with i386:x86-64 output
ld: i386 architecture of input file `lib/libcflat.a(argv.o)' is incompatible with i386:x86-64 output
ld: i386 architecture of input file `lib/libcflat.a(printf.o)' is incompatible with i386:x86-64 output
...

You can find the job definition in the .gitlab-ci.yml file (it's
basically just about running "configure" with --arch=i386).

  Thomas

