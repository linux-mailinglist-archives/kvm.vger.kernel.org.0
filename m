Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07C761054F
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 00:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbiJ0WCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 18:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbiJ0WCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 18:02:53 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BC79F355
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:02:52 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id f23so3067054plr.6
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRekDwqgc0AapKuh74g54fnT9rqPvEgwK/a37iW+IP4=;
        b=o3KJm5RzMh4qQZPPmxXUlmqo1MUZnNoIZAeWds7ry2/GBuAFtWDCAUXBy6+DFK+rHM
         NCPxkqowQruPnB/zdphVQNYr415w43vHQlD1JoxSwF1/8B25znWnYe3qruzQNtvMD4YW
         dPl2RxUJ3WjDzhB7sKrqAesG5amVCkWs72HANDwXx8OyGNscuio3hu90VeMmKNVMKhbE
         VDOYNeZVSXomp9FUxRprW3lsdx9ycU4Qp+iCuMwyf6apjHvrs3Dkcx2C2cNMeOnyI+MZ
         D1KE8fqyi6t/krz2Q+UEDyGnPRkJexjqqksMvdRnqBghU+EkN99pi3V5qkJlZ2TWTgyK
         9x6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZRekDwqgc0AapKuh74g54fnT9rqPvEgwK/a37iW+IP4=;
        b=JdqfAsalpoD0Rg3R2I2mcyROvQisNOkqc743waT+gzzwUzGbfwLL/GOUBS7nnQP+ai
         0HUtAz2AA7fFgJkXQ1BIpGIq+H5m3qB4oivmjPcblQVnq8oy+c6Ir7ufmd1on3fnAHyO
         wicDSGfbQzcy28UbaMz4o2muXl8r9jImtu+SMKaqFeAQozGqABEbk/vI8fC3Uv8bMbq9
         dKRZcM0NqioKusRuC3vNrNhD65wRJ9MzQab+PygZXJUqAzNJYj7IgKAJP4FaW7eQffxE
         wiLCGlWCFMqRzS3QtHNjz37MOul0B+RM1xuCsZ+sK+KmR/+PJRnkEGOrStYgEi1dw7w+
         AW8Q==
X-Gm-Message-State: ACrzQf1qAUNZzjdp7WiCz/I8Apq1ElLlQFJlEJhLkO4qjmkYYZjFN5I3
        ENU6oFIJyY9k1dndyhsUegm+xw==
X-Google-Smtp-Source: AMsMyM6i3hFCANeukyRz00irSwKLCFJtPwWxp0OkMDSYS8UpBc70vF36rpJsUO51aJtYOgPsqavkuA==
X-Received: by 2002:a17:902:ce0d:b0:178:bd1e:e8da with SMTP id k13-20020a170902ce0d00b00178bd1ee8damr52061114plg.103.1666908171410;
        Thu, 27 Oct 2022 15:02:51 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 197-20020a6216ce000000b005622f99579esm1607649pfw.160.2022.10.27.15.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 15:02:51 -0700 (PDT)
Date:   Thu, 27 Oct 2022 22:02:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v6 0/7] Introduce and test masked events
Message-ID: <Y1sAB0LlTPwnWjZp@google.com>
References: <20221021205105.1621014-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021205105.1621014-1-aaronlewis@google.com>
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

On Fri, Oct 21, 2022, Aaron Lewis wrote:
> This series introduces the concept of masked events to the pmu event
> filter. Masked events can help reduce the number of events needed in the
> pmu event filter by allowing a more generalized matching method to be
> used for the unit mask when filtering guest events in the pmu.  With
> masked events, if an event select should be restricted from the guest,
> instead of having to add an entry to the pmu event filter for each
> event select + unit mask pair, a masked event can be added to generalize
> the unit mask values.

...

> Aaron Lewis (7):
>   kvm: x86/pmu: Correct the mask used in a pmu event filter lookup
>   kvm: x86/pmu: Remove impossible events from the pmu event filter
>   kvm: x86/pmu: prepare the pmu event filter for masked events
>   kvm: x86/pmu: Introduce masked events to the pmu event filter
>   selftests: kvm/x86: Add flags when creating a pmu event filter
>   selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
>   selftests: kvm/x86: Test masked events

One comment request in the last patch, but it's not the end of the world if it
doesn't get added right away.

An extra set of eyeballs from Paolo, Jim, and/or Like would be welcome as I don't
consider myself trustworthy when it comes to PMU code...

Reviewed-by: Sean Christopherson <seanjc@google.com>
