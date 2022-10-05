Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC575F5C9E
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 00:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiJEWWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 18:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJEWWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 18:22:39 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A373201A5
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 15:22:39 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id l4so962plb.8
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 15:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ysu4em/qzkKaXf8CyCepB9wbGgGVgPp8PFkJm90nBnY=;
        b=JIxp+IIe2KFvAvFyU5Ni9hnNgzT6im27Jcs+iCUdDK8eYmFLtEhWYnhSSzpK2TBHlS
         cvM+W4BmwuhG8OzbGP7g60dJ12xh3gscToaSz5M+qgeDH9xJOuOJkPT9eaJ36EnUYwvF
         DXcNbNkVG/qa4z7ZWu4wFVPToGe03EtPabaCiOxjCLcO7D0MSr4NSRxjc0wuCto3CFzs
         EoxRGPPpqEmlqMorJdSKNY96AmryJwHZpHXn/EKH4yniRYeogPec7WYyUrBZP3XM01ox
         9azlXmot6ySpv5tTsQLS3N1IA+++3F2XNk7k6gdrIs8ZkfLjUXGpp2fzWZyl/kUemo81
         /2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ysu4em/qzkKaXf8CyCepB9wbGgGVgPp8PFkJm90nBnY=;
        b=X4lnyJwZymTtasTu07Y2kzEUWBjOwqYwuTmT7ZaTAJJk6R3y7m4Nl69AKYHCpUH74m
         uHhZXLa3CykeU9TP6QtrUKcUqaB+0kgljYqXB2OpJfrDnAK4v3yH4ezyGY0i0LnEiheJ
         hqzBHSxvvu33i1pBDi6+GxxRKleQaAuE13ucYQsFIQgjbKinaWjxvl7w1DgEpo07MpMw
         wxNVTAg2lk4t8GXgsLQkqZ/YswD0SabptI/MEAgnDCqEz8nnSj+IJlqBbFctLEZ1RvgJ
         tvj5dXkJ4ce23uzzPxE0HDTteK38v37WnU6fqfyzsmLhT5b2BQsRg5bBqecCfXJXGwdd
         s8fQ==
X-Gm-Message-State: ACrzQf1mdmZd+Via9oQMQW3nkZnmKG4ImyV/6OB1W+WHD24oWB551UR9
        Py2g8y+7TmMnsqa8/5VrSWC1bg==
X-Google-Smtp-Source: AMsMyM654f49pN+XuEk9G+/fAs82w07y1myAB0GOBhV5pmxmn2Sm6JBuVYI/O5yvdms+3nxEsqAJAg==
X-Received: by 2002:a17:902:c40b:b0:17e:9bde:ace2 with SMTP id k11-20020a170902c40b00b0017e9bdeace2mr1737937plk.91.1665008558542;
        Wed, 05 Oct 2022 15:22:38 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r17-20020a635d11000000b00459a36795cbsm247669pgb.42.2022.10.05.15.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 15:22:37 -0700 (PDT)
Date:   Wed, 5 Oct 2022 22:22:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 04/13] x86/pmu: Add tests for Intel
 Processor Event Based Sampling (PEBS)
Message-ID: <Yz4Dqs8/vCqKAy5H@google.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-5-likexu@tencent.com>
 <Yz4DT4tz0Lrsgu0J@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yz4DT4tz0Lrsgu0J@google.com>
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

On Wed, Oct 05, 2022, Sean Christopherson wrote:
> On Fri, Aug 19, 2022, Like Xu wrote:
> > From: Like Xu <likexu@tencent.com>
> > 
> > This unit-test is intended to test the KVM's support for
> > the Processor Event Based Sampling (PEBS) which is another
> > PMU feature on Intel processors (start from Ice Lake Server).
> > 
> > If a bit in PEBS_ENABLE is set to 1, its corresponding counter will
> > write at least one PEBS records (including partial state of the vcpu
> > at the time of the current hardware event) to the guest memory on
> > counter overflow, and trigger an interrupt at a specific DS state.
> > The format of a PEBS record can be configured by another register.
> > 
> > These tests cover most usage scenarios, for example there are some
> > specially constructed scenarios (not a typical behaviour of Linux
> > PEBS driver). It lowers the threshold for others to understand this
> > feature and opens up more exploration of KVM implementation or
> > hw feature itself.
> > 
> > Signed-off-by: Like Xu <likexu@tencent.com>
> 
> I responded to the previous version, didn't realize it got merged in with this
> series (totally fine, I just missed it).  I think all my feedback still applies.
> 
> https://lore.kernel.org/all/Yz3XiP6GBp95YEW9@google.com

Ha, and then I saw the addition of "groups = pmu" in the next patch :-)
