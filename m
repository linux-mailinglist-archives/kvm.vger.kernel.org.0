Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500357B9DCB
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 15:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjJENz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 09:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244122AbjJENv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 09:51:28 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001C1900E;
        Thu,  5 Oct 2023 01:43:53 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2bffc55af02so8388001fa.2;
        Thu, 05 Oct 2023 01:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696495432; x=1697100232; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QBC2uDtuvLWSi+e86bmiqwkGBFvL8QuJ4aOmK9HEZfo=;
        b=FODaaRr+DD3bvEFxfYLxGSpdJo9eIa/UCutscm9Vl0i7fG7UifY7XDiw/9JThhmXy4
         69Su6HxBVRMdng7Qgu6HHsPpsdN1Uhcct+jyDzQmNL9nKCm8sa2hnzoYn11Qdj2MrP6S
         duVfO9MZb+VI66lMktn168ClpxgkC0VHUe98UuJtwIrbxSodGMLF4z5gvLspK5p9Kqrd
         F0oyLSmoUXHu2fqfIjfIXXU6u6vyhM15BZBrLaG6FhuJEhC89GO5AZpCXzQJx+v+2t+R
         wC93hzZYZ20LymCkb+BlrGwaInD6DhSBN1tc2Dm9Fx9cwkfiP5J84LzgXMh4QNmWTQrG
         xj2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696495432; x=1697100232;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QBC2uDtuvLWSi+e86bmiqwkGBFvL8QuJ4aOmK9HEZfo=;
        b=nDO1QCp3dz9YgeimZPDfi9tvR/1daFZDyKuNtKwVf8x6Ox9tNSd6rTnZO/b97CPdz7
         iC9JkCgNhvDNJEiu7ti8zKzIurIiElRHTZXnQJAdMa3/nIlnrmHOXYGhAf9iZiXVVYgO
         HWnmdss8HPzOz2Cg68g0AjYc7T94LMdY9dQ8V+jgq5f4X3tXgAUmfHYKoGNnTBpw1tYV
         11Pt+QIP7AWZh3ZaNTVgU3uXmJXRgLOSgrX/uv0SpNAk9kWvYf0t4odcqCf839qx2xdQ
         3vt+n8ZCE6Vwh26dPB1w+H/6WLqQFrCC9AxGZhq0FvTl4Zka6LtA1YfOkuWZ42xHfo2Q
         ihNA==
X-Gm-Message-State: AOJu0YyHgpfJQ0mhtFkoH20zlKpjWa1sQJH9vYQZ4aTViHeb9QZvbU9p
        k05OkBS2iPDP6OGRC65H42g=
X-Google-Smtp-Source: AGHT+IGLxYMqINl2xvFOVlAWWdWvAHjxa0O5+DczsG2ph9KmPgAhiGT1sjud2lhvMs8n46YT81uZNw==
X-Received: by 2002:a2e:9c99:0:b0:2c0:1bf9:3c95 with SMTP id x25-20020a2e9c99000000b002c01bf93c95mr4213556lji.24.1696495431882;
        Thu, 05 Oct 2023 01:43:51 -0700 (PDT)
Received: from [192.168.196.210] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a11-20020a5d4d4b000000b003231ca246b6sm1233559wru.95.2023.10.05.01.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Oct 2023 01:43:51 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <5fc0fbfe-72e8-44bf-bad2-92513f299832@xen.org>
Date:   Thu, 5 Oct 2023 09:43:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2] KVM: x86/xen: ignore the VCPU_SSHOTTMR_future flag
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Durrant <pdurrant@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
References: <20231004174628.2073263-1-paul@xen.org>
 <ZR2vTN618U0UgtIA@google.com>
Organization: Xen Project
In-Reply-To: <ZR2vTN618U0UgtIA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/2023 19:30, Sean Christopherson wrote:
> On Wed, Oct 04, 2023, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> Upstream Xen now ignores this flag [1], since the only guest kernel ever to
>> use it was buggy. By ignoring the flag the guest will always get a callback
>> if it sets a negative timeout which upstream Xen has determined not to
>> cause problems for any guest setting the flag.
>>
>> [1] https://xenbits.xen.org/gitweb/?p=xen.git;a=commitdiff;h=19c6cbd909
>>
>> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
>> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
>> ---
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: x86@kernel.org
> 
> If you're going to manually Cc folks, put the Cc's in the changelog proper so that
> there's a record of who was Cc'd on the patch.
> 

FTR, the basic list was generated:

./scripts/get_maintainer.pl --no-rolestats 
0001-KVM-xen-ignore-the-VCPU_SSHOTTMR_future-flag.patch | while read 
line; do echo Cc: $line; done

and then lightly hacked put x86 at the end and remove my own name... so 
not really manual.
Also not entirely sure why you'd want the Cc list making it into the 
actual commit.

> Or even better, just use scripts/get_maintainers.pl and only manually Cc people
> when necessary.

I guess this must be some other way of using get_maintainers.pl that you 
are expecting?
