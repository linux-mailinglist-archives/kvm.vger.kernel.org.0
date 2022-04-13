Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F59E4FFFAD
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 21:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238443AbiDMT7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 15:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbiDMT7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 15:59:46 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36A871EC4
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 12:57:23 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id b15so2931911pfm.5
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 12:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MG3quSoNsNwV3oupePcTrzAr607WOQoHZdwQe1pKKzI=;
        b=KWCZ3C9qZm1FUt+mOwJC6ei7hb4/8IwRm8WsFxmf3zmjkWgFUmZTMRMWk0mi95EkKu
         U/t5vSSXkUJHC9YJ/GUypyEZLZt5PoVPhqZBqvuWwdun7+3PQl8CACNCGpGBx+kzDyDN
         dNcfSeiNZ8TXp9Npcin2MbgWrzIg8qYAEKnNRVq7LpowG8GMNTYR6/wUMlqqn/NS10ec
         B9c/aC9ZwbsfmgPY3j1LYV375G+jqX/jkC8NYnPjti2q+NqdihrIv4Tc4kx5QIsAB8e+
         zureRSHckU6SUlPltqAvsmATwcWJ/SnXbzM03A83sf2bco78AkJTIPQTXyp+QsgDqP5y
         kA0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MG3quSoNsNwV3oupePcTrzAr607WOQoHZdwQe1pKKzI=;
        b=hWvGJGOAyctgGpCYIYEbfC0mS+413aDv37WKKPgm7K01046r5NVyVfwulW901hfME7
         BIVDlCTiVpT1n+CPHmHStf0SyiqdMQLvXxfOEuFcrH57f54VCnHRFteYCyGP075x5pS3
         noOX/s1jrexZqCEB19NaLFVXvpgWB/rby86a689Oiy4uBlHOUyrTKYTat0AxXvEwBbOo
         ksG2srEjYfXgRcGqmpvVQDwLj6QUcCMXyqmqwIW01wNHg49bT0ciKQ6FkBa6i59MAeL+
         hQ1BTUbf7LQ38BgmPfjAHRBHphecw3HMEKfQaPi4Qxy8iyibNKevv6xiNHu3pUd9Ys0u
         96XQ==
X-Gm-Message-State: AOAM531bBc6bv01VTxwtCP1RelOlxLoPIe324aKPKwpB83+Jwer7dqQP
        4DrC84vfprpJNU5GqVHdZyGdCQ==
X-Google-Smtp-Source: ABdhPJz68Tk5VrUGd/v9PSiFMlpSAga0W7SkNU0iMPVoRwUcglJYTziNeUjp75ChPbBrzC4JDYTe6Q==
X-Received: by 2002:a63:d4f:0:b0:39d:4442:277a with SMTP id 15-20020a630d4f000000b0039d4442277amr15090028pgn.221.1649879843131;
        Wed, 13 Apr 2022 12:57:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a21-20020a62bd15000000b00505b8bad895sm12289900pff.106.2022.04.13.12.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:57:22 -0700 (PDT)
Date:   Wed, 13 Apr 2022 19:57:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 00/10] SMP Support for x86 UEFI Tests
Message-ID: <YlcrHyFqxKM4OQl7@google.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173407.13637-1-varad.gautam@suse.com>
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

On Tue, Apr 12, 2022, Varad Gautam wrote:
> This series brings multi-vcpu support to UEFI tests on x86.
> 
> Most of the necessary AP bringup code already exists within kvm-unit-tests'
> cstart64.S, and has now been either rewritten in C or moved to a common location
> to be shared between EFI and non-EFI test builds.
> 
> A call gate is used to transition from 16-bit to 32-bit mode, since EFI may
> not load the 32-bit entrypoint low enough to be reachable from the SIPI vector.
> 
> Changes in v2:
> - rebase onto kvm-unit-tests@1a4529ce83 + seanjc's percpu apic_ops series [1].

Thanks for taking on the rebase pain, I appreciate it!

Lots of comments, but mostly minor things to (hopefully) improve readability.  I
belive the mixup with 32-bit targets is the only thing that might get painful.
