Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5705F6E89
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 22:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbiJFUCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 16:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiJFUCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 16:02:43 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0DFAE229
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 13:02:41 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id 10so2739380pli.0
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 13:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LIiTWkOpc8IzCdKyYmBTbqUM+MiKg43asT5Ky3ZBVwI=;
        b=ooT7SiXeA4500qzGPoywjNXFF5+ELJzGuZAUMqbhPgAGkzbHLnE/cwDCsneFlyZG0e
         E22lPbo9DM/HWiWMfq9uWBeiBbMmjRlEPIe73g4XZYzrGXj2Jus4otCH+LLs9IeBz3Hi
         5fGUASoctRPM96EIdp6RLs5081H2ERpbPbdUQ114tVuEgqRxOJ49CPX5qkdFZLGGjAXx
         jE/zkiUE1M3y9x9osVzVFal5qf07uDg7IwiHtRVdq79Ske8YOGYGLhyqKnp5VBKsFxRG
         eTTPsbGZocRImg5FtedstKITSAxajN4RNWwVyNspnUTvrpM+olsMRc8l+JMA0zLxKbA5
         8KLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LIiTWkOpc8IzCdKyYmBTbqUM+MiKg43asT5Ky3ZBVwI=;
        b=KSFJIay3Dd2e7tZzLLbJqDW8KGHoVdN82x1H/BBpmldl4af1qwiObQUr40isZ+znzN
         S3e+UXGYokfojONDLH5QNdDn7PeogAl47QS4otTrb9zGpQtDou6PeKP+4Buv6e8nlW30
         4FbMQ5PDc7ihYO28aObdTUiJK3YrdzuAgABVED/7WbCgGWlqiKqDsQCfu7X0ugdemwin
         A8W7fO6Tpj6/SXaNv7F4cOv7ZmuCRDgPjWxgLE3EdQG82MmX3NfbFW5x64Op9kIfuEV1
         NhHu5hgtpTRWzseF/ZnUL001P/vcnV5n3uyqZ2oDO5noIXjbi085u1dme8bOZ24PfFCF
         zSwA==
X-Gm-Message-State: ACrzQf2reY21sBWoJDAIARo/+CPQDbCqPPaihS9J8Fw8iTX7bOLzRtkJ
        E4vUDXCLJAzx0+h9KfqFkWWOGg==
X-Google-Smtp-Source: AMsMyM6Oj0yBqJnAj8XCfZNWm/5C6Fnv8+9xRuwhZtTVRNy3EpLf7BIbZB2nRwVOJFC9zE76VDNv1Q==
X-Received: by 2002:a17:90b:4b41:b0:20a:fe8f:5a3 with SMTP id mi1-20020a17090b4b4100b0020afe8f05a3mr7230387pjb.120.1665086560817;
        Thu, 06 Oct 2022 13:02:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f26-20020aa79d9a000000b00537a6b81bb7sm5772052pfq.148.2022.10.06.13.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 13:02:40 -0700 (PDT)
Date:   Thu, 6 Oct 2022 20:02:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        shuah@kernel.org, yang.zhong@intel.com, drjones@redhat.com,
        ricarkol@google.com, aaronlewis@google.com, wei.w.wang@intel.com,
        kirill.shutemov@linux.intel.com, corbet@lwn.net, hughd@google.com,
        jlayton@kernel.org, bfields@fieldses.org,
        akpm@linux-foundation.org, chao.p.peng@linux.intel.com,
        yu.c.zhang@linux.intel.com, jun.nakajima@intel.com,
        dave.hansen@intel.com, michael.roth@amd.com, qperret@google.com,
        steven.price@arm.com, ak@linux.intel.com, david@redhat.com,
        luto@kernel.org, vbabka@suse.cz, marcorr@google.com,
        erdemaktas@google.com, pgonda@google.com, nikunj@amd.com,
        diviness@google.com, maz@kernel.org, dmatlack@google.com,
        axelrasmussen@google.com, maciej.szmigiero@oracle.com,
        mizhang@google.com, bgardon@google.com
Subject: Re: [RFC V3 PATCH 3/6] selftests: kvm: ucall: Allow querying ucall
 pool gpa
Message-ID: <Yz80XAg74KGdSqco@google.com>
References: <20220819174659.2427983-1-vannapurve@google.com>
 <20220819174659.2427983-4-vannapurve@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819174659.2427983-4-vannapurve@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022, Vishal Annapurve wrote:
> Add a helper to query guest physical address for ucall pool
> so that guest can mark the page as accessed shared or private.
> 
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> ---

This should be handled by the SEV series[*].  Can you provide feedback on that
series if having a generic way to map the ucall address as shared won't work?

[*] https://lore.kernel.org/all/20220829171021.701198-1-pgonda@google.com
