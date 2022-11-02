Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69707616B13
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 18:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiKBRlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 13:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiKBRlm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 13:41:42 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56454B53
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 10:41:42 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id g24so17262831plq.3
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 10:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rQonhRLZcvIf3pPeYCSXFil/xqWYd/R0+ClJdgYwaVs=;
        b=nl/vaDuH3XNyQ05wty7IKZ++c+mBWbXOCAe9X4MJ+Tbkedgz+ABVQIIvBw+Xblm3S4
         63ZOcuQnrYlRF1psqBUam2gsMhcRyUK/0PXFOWHIaB7Y5m0pxX3ZqEyWHyGJDNZ47m3r
         vVEHNWIi1lxdmzTUUMPm5cB2ypUKXBcE2UYxIiiSW9qUAxHHv11YYcnn2m0+CzNEXt9D
         UB9lRK5+U/ZWtaX9oHrkOwTZQIyhm3vZuAwYz5sINKbmJTe7Q9zK0wWYXVSXb1eMidQJ
         fa1cEIW8/rh0aiSf2KMPac3LcphDHdXvDZtdlPDvi5XV42OTQ+8qrC2sM7LboILAp/Sn
         eKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rQonhRLZcvIf3pPeYCSXFil/xqWYd/R0+ClJdgYwaVs=;
        b=TvZkgLikx8jivC1Ml/sIQGz0Oc1BENepww2lkwB9ZTKESLwDCWh4bKWvr+qvbBPJbs
         c8oZwbyD2ba0T7yCMigSZIxbyj+J/rJENPkab6M/7lewY0MmShQEpDsWCRKm2EnclISb
         prUy++zdnh5OoXBuTE2FcXmONRMvG9tYJ3lcojUkIIBHarV7BYSPmgkqgdCLeoiHv5gI
         Cbwn+9oezkVBwzRgexsiRJU0waiG0t8GbsUcQIXfnFbOzt9gJrxqxAMesQh+NIaRlWP5
         JfyLVUnIIvPBmmQAS37xfTBWJ8q1pB92pIQ7loA2dQ8ooVqrH1vVt0jkm1XXde0wtLw4
         QL/w==
X-Gm-Message-State: ACrzQf1UoLLKBOB0SSZ/pbtoU5+rXvHganqF29uR87iYBHSAWBy8BXDw
        lpDw5VcXaslTeiW+bjsHWVhk9ivx2wjbgQ==
X-Google-Smtp-Source: AMsMyM6MZgRK4rIb226ItZ0WEBVMLuJ2JrstqOLszYNz5UT/Fss/yN4DVsVi2FbqGkrnJ7fkXOahDw==
X-Received: by 2002:a17:902:e88d:b0:186:c544:8b04 with SMTP id w13-20020a170902e88d00b00186c5448b04mr26326078plg.51.1667410901803;
        Wed, 02 Nov 2022 10:41:41 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 22-20020a631656000000b0046f9f4a2de6sm6646672pgw.74.2022.11.02.10.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 10:41:41 -0700 (PDT)
Date:   Wed, 2 Nov 2022 17:41:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 06/24] x86/pmu: Introduce
 __start_event() to drop all of the manual zeroing
Message-ID: <Y2Kr0SRHomJIQQXh@google.com>
References: <20221024091223.42631-1-likexu@tencent.com>
 <20221024091223.42631-7-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024091223.42631-7-likexu@tencent.com>
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

On Mon, Oct 24, 2022, Like Xu wrote:
> +static void __measure(pmu_counter_t *evt, uint64_t count)

Note, this will silently conflict with another in-flight patch[*] to mark
measure() as noinline.

[*] https://lore.kernel.org/all/20220601163012.3404212-1-morbo@google.com
