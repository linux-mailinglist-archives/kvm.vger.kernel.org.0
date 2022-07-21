Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1887D57D3EF
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 21:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbiGUTQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 15:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbiGUTQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 15:16:07 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5AE82FB4
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 12:15:36 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id bk6-20020a17090b080600b001f2138a2a7bso4931385pjb.1
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 12:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oMZZC+8JiWNPdO3p89XFrwQ0EUK9QvGO0SjlJvpm60s=;
        b=EnGhxYAoJTh70GJF69IyOINYkhg1qNTdCf7Cxqq1yVIuuqkzSnnj3EnXzgjVaeSFn9
         e7Zfffvex8sszVeMKPYzSDNN+Xps8N7X+b1DAfAGCot5XCHUKXXk/tX0wJouas1ZTmkg
         Ig76WtuRxckRq/X8oJ0P1Rck2zUKv6lPiV4RElEc7wyxGFvQpD1X+lezj3Slr4I1gV7q
         YgNWRrZvcKuBKzC66g9WVskQlO4KED66z4j4FQZpLy3FuGVZh8wr3+QoQwVmFEwv29lO
         QE7CCxQ8vm3y26dJqonOMfKzKuEVuQ9bXsEEyguNy1h+PK9UDW7ldlyAlHK0DR/ar3WN
         ONvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oMZZC+8JiWNPdO3p89XFrwQ0EUK9QvGO0SjlJvpm60s=;
        b=CbvdsI80mskvsN1g8Q8YQArHfnT6p5Jm132HHHOPCBfKqZd99WxjR8I+B0HJ/6KRrV
         fE9pTQTgwf3AwI44ju69Ti2hlGjqxYpoLQG+mMAGFW20NY11BbKxQz1KCTfv0HluN9ta
         307LIcdGDQYXVdPzgi+MGi+j2VZCJN5zBeKEZifebsCc1FMXySjImcjLpkPS/9chKH00
         Ley9I8ZJktGu4P0kUAa0koKpnnhWt7FLCZ37u/8NNgEnMJSYs5ebKgpVoQysBO6L5tgG
         RRa/MDn/V6VNLWRBWFIWV1BgLxO9OBbo/SfswJid2Nct608WE4JEPHqh/9B+rMWMKj/+
         xgbg==
X-Gm-Message-State: AJIora8flAqCg1hG7CwO7PsQCTIJNjj2ZHDZ71HS5y+UDM5SSbkpxs+K
        B9WEjsdKP4fYACgR6+JBezI6+Q==
X-Google-Smtp-Source: AGRyM1tSxgF+m/BOsgE3T8gyfGZR1Khmxuv3/4UrHk57oWK9Nz6lUPxgJk3+ADczNytu2OBRXJvDnA==
X-Received: by 2002:a17:902:ba91:b0:16d:3119:7fea with SMTP id k17-20020a170902ba9100b0016d31197feamr4666656pls.57.1658430936207;
        Thu, 21 Jul 2022 12:15:36 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id gb17-20020a17090b061100b001f1694dafb1sm1757043pjb.44.2022.07.21.12.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 12:15:35 -0700 (PDT)
Date:   Thu, 21 Jul 2022 19:15:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v5 0/8] Move npt test cases and NPT code
 improvements
Message-ID: <Ytml0zc1cJh5tRG9@google.com>
References: <20220628113853.392569-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628113853.392569-1-manali.shukla@amd.com>
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

On Tue, Jun 28, 2022, Manali Shukla wrote:
> If __setup_vm() is changed to setup_vm(), KUT will build tests with PT_USER_MASK
> set on all PTEs. It is a better idea to move nNPT tests to their own file so
> that tests don't need to fiddle with page tables midway.
> 
> The quick approach to do this would be to turn the current main into a small
> helper, without calling __setup_vm() from helper.
> 
> setup_mmu_range() function in vm.c was modified to allocate new user pages to
> implement nested page table.
> 
> Current implementation of nested page table does the page table build up
> statically with 2048 PTEs and one pml4 entry. With newly implemented routine,
> nested page table can be implemented dynamically based on the RAM size of VM
> which enables us to have separate memory ranges to test various npt test cases.
> 
> Based on this implementation, minimal changes were required to be done in
> below mentioned existing APIs:
> npt_get_pde(), npt_get_pte(), npt_get_pdpe().

I have a variety of nits and minor complaints, but no need to send another version,
I'll fix things up as I go.  I'm going to send Paolo a pull request for KUT, there's
a big pile of outstanding changes that have been languishing.
