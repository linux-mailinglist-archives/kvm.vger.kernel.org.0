Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF4557DEF7
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 12:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbiGVJuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 05:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbiGVJuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 05:50:17 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CD73B5;
        Fri, 22 Jul 2022 02:49:29 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id b26so5783969wrc.2;
        Fri, 22 Jul 2022 02:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s97o5WfeUXiwF1BWIZTPHEPF/2SnbCzSLHtdxOynKBw=;
        b=M/nv3mivUNxOGfowys6oRol4cEr46DRd6VxwXNpwD2TBf+3cpGMOKMZMwJu7GHp0GJ
         rN4uYUzL27Py2DHZZaZafBzZGWQ/u98yEDhwyh5kpyFgP1oEjIBkhIyKdimPxELQ60mS
         5f/pSYcxWmU2b1xHv7nVHrMGWipu+SqHSoDIwEDHjNGCEoRQQCew7IysVefObIFuTEBw
         aY0rKiZQLnfYIGyjHolbWh0IljYZSxc4lXU/3fdZYg7iezUeqlvbQA9VbfuR7kD8rTeG
         pDOCOuwaaw2nEDrqt+xYUZrXdoeAIazBSo0chdBoTCpNdkac/mZ2rguu/5EmDOyHT9Ru
         XWZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s97o5WfeUXiwF1BWIZTPHEPF/2SnbCzSLHtdxOynKBw=;
        b=dkGS/iGbk3YAc9zhjg3n9LDOf89gVrFx/3Q7s1kU4y2F+jPHmfaCWzZ+4KQo9DrISH
         3TNgBj0psGjhH0QFueIG4xqgzD6ppwZ4CyzH/gTrm64KsfEGJyVx5hrfMBgkHCTkm2mx
         1gmTW2c5DxOsr3Jjqw6SM9bMsCRDCk5n901yl4uH7m3jMas3aIiSOk8OO2DBQK9rizlF
         paz1drSq1DI7k/a0QBkLEy9UHk5iwbhpJDt9xqf/PFJJLfuNffx5AqcJFCwWX+TSD8LZ
         0osCoBESXcEZLOl/+oNlolc0TSCOEmBPAvS2WnxzzdfzD+0r2qiEzSrexKT83YtJRsxf
         +1DQ==
X-Gm-Message-State: AJIora/Ioo/dn3nUNTIhkTiAjbaP7zF8+itYdbi8YR2wAKuKdy1SIRtS
        0UWcyypPBfs30h8BwsnFZ+I=
X-Google-Smtp-Source: AGRyM1sqR++oyLPmvuyH0cIhzNNsPztpmjf+IZPgbnKDJiqqCzItevLk80Jb4La9PljQjCFWDXMxaw==
X-Received: by 2002:a5d:6b02:0:b0:21e:4c90:f4 with SMTP id v2-20020a5d6b02000000b0021e4c9000f4mr1874160wrw.385.1658483367775;
        Fri, 22 Jul 2022 02:49:27 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id o8-20020a05600c378800b003a2e7c13a3asm4194962wmr.42.2022.07.22.02.49.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 02:49:27 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <40500f56-5ea4-f0c3-2a75-290ed20c9c81@redhat.com>
Date:   Fri, 22 Jul 2022 11:49:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v5 11/15] KVM: nVMX: Set UMIP bit CR4_FIXED1 MSR when
 emulating UMIP
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
References: <20220607213604.3346000-1-seanjc@google.com>
 <20220607213604.3346000-12-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220607213604.3346000-12-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/7/22 23:36, Sean Christopherson wrote:
> Make UMIP an "allowed-1" bit CR4_FIXED1 MSR when KVM is emulating UMIP.
> KVM emulates UMIP for both L1 and L2, and so should enumerate that L2 is
> allowed to have CR4.UMIP=1.  Not setting the bit doesn't immediately
> break nVMX, as KVM does set/clear the bit in CR4_FIXED1 in response to a
> guest CPUID update, i.e. KVM will correctly (dis)allow nested VM-Entry
> based on whether or not UMIP is exposed to L1.
> 
> That said, KVM should enumerate the bit as being allowed from time zero,
> e.g. userspace will see the wrong value if the MSR is read before CPUID
> is written.  And a future patch will quirk KVM's behavior of stuffing
> CR4_FIXED1 in response to guest CPUID changes, as CR4_FIXED1 is not
> strictly required to match the CPUID model exposed to L1.

I'm not sure about this; there's no *practical* need to allow it, since 
there is generally a 1:n mapping between CPUID and CR4 reserved bits. 
Do you mind removing the "future patch" reference from the commit message?

Paolo
