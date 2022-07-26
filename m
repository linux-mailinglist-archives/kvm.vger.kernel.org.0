Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA5D581849
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 19:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239069AbiGZRXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 13:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiGZRXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 13:23:08 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4F36417
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 10:23:06 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id e8-20020a17090a280800b001f2fef7886eso1284118pjd.3
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 10:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/OqsrOTLkjBEAzj6fLwmJRc6IwqAp6rTf1R7SLIbSnU=;
        b=l8iR+uVRAduws3yNPBEf68/c/vhKz4rJNv49xy6Dy4m0feP4lErlpKDOtYdAGAPtKR
         k6He26FbkWRHb3gguWww4e4LuxxJRnPTyo6kjQRcODdfu7FLzW4AjKnHD3JAyzV6+CUf
         uUqOO49Le6CfnChp6T5SSsLjB6c7IbTUu4Rq6NBRsBm+mEk6yGcQiNUnWRwBwNY0Ok/p
         UWsmhYY9T+zC181SlIu2UnANgpK5VMIB7Bn9T3zemVF0dPNZlmck/AG//DaUu7NSfaHo
         sBJhTOvlVurYN47pQ+m9QMyHT6BepnMPxFf16gxK9YpRlaZw9TUWFd7RCLE9/Q8CGrxD
         PvNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/OqsrOTLkjBEAzj6fLwmJRc6IwqAp6rTf1R7SLIbSnU=;
        b=6036npH2pPReU04E3dgDjlFz6p1enlZVLa2LjapX4/o2VzxVaBoY2oLbXeRyvHPohm
         afrdQKCNDMP7p4vAt5Di4+0n6v2MQZtkoQxvLpSIB/o4rP1VZDGNABnIjXRNiD1Jrkjr
         evtQbOLBZm/gMEa0pD3aiZXTAO/hWgSLja8SQLZUf5EMCNnknOu+js+jwDTL2APo83Pw
         Jmx8OPD5vc93dGjcPt9sgqTXmLB3GSn86APp1FxR/PzP3UYGxCAhcLSNphSO6aqzwMb+
         +qyUuHPIcQlZT96hZ8KoX+1M5uJ4jY1gEAMsYtWkiO97+zQEibMwlTk2rTdrH9xhydOL
         lheA==
X-Gm-Message-State: AJIora/OYUE++t2jgwzoT/nC9b3aHUJwLVdUyXvAT99WVyskn4iCAX5F
        /c1cs4VqXX/5WXHTZsSfEp7R3Op4tyaszw==
X-Google-Smtp-Source: AGRyM1ts6YyomE64mggXIWfJWK1IM9LvgPN9dL5mdu4hjSW8MD3oTHZ1RDqiNWgf14OMcBcHcN/09Q==
X-Received: by 2002:a17:902:ced2:b0:16c:ff1b:a6d0 with SMTP id d18-20020a170902ced200b0016cff1ba6d0mr17143923plg.154.1658856185993;
        Tue, 26 Jul 2022 10:23:05 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902e30c00b0016bdb5a3e37sm11641257plc.250.2022.07.26.10.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 10:23:05 -0700 (PDT)
Date:   Tue, 26 Jul 2022 17:23:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests] x86: fix clang warning
Message-ID: <YuAi9dpL58+dOAgQ@google.com>
References: <20220726150331.91457-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726150331.91457-1-pbonzini@redhat.com>
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

On Tue, Jul 26, 2022, Paolo Bonzini wrote:
> x86/vmx.c:1502:69: error: use of logical
> ---

Sorry :-(

Reviewed-by: Sean Christopherson <seanjc@google.com>
