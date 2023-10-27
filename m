Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646397D8FE1
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 09:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345363AbjJ0HcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 03:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjJ0HcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 03:32:01 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4ECB0
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 00:31:59 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-4083f61322fso13676135e9.1
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 00:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698391917; x=1698996717; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3WQCodtLeMa/vLM2901WzSloIhFtxV+9ehL3oSRrzfA=;
        b=TV9HGxhhpgnM233p7rVUx9qFl4LXgGmBDN0CFQNJvZRvMie6bctKlVkkg2IDeTRbVw
         sscR4PcpdbqSZFRMSoeiYXzXzoePzgPx4no0MwR8pMnZ1cFnVlj9xMS06aDU0hqLhnPc
         QVJDnZe2yykHBxAz1EfrokW9XqHrFls9v5O+4xJPsftM6JQ44CP0WL5gJ4KQVmDaIwwi
         dCmfrME8g6D2AnB1HrStXosW6uOa4FEcidzZ3RCFYqaJNdwc4m0c0L/WW+CBWvx10m20
         8upiOLLqGXWaOAyw9VC2Wh2V7DpYYEHSv/kHi5qT58nkntI+WtJ/22d5zElnMf2cUcET
         QGtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698391917; x=1698996717;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3WQCodtLeMa/vLM2901WzSloIhFtxV+9ehL3oSRrzfA=;
        b=k/lFTktGxUocpO8v2JUBz1iZf9n/Cut6dZ75NQo4hkqkFSQaWBUr8FcDkGcQw11Uha
         A/WeReRhkvm6RXmTiqfKfeJQ0eIpBYV2KLY+yWk8cOKTijw4xWHj4VWHifUldMkRLVeV
         EfY29396A02Qw89I90BLc+FQV84ss6CmZC0/royju/lgRceCdLD4AltcKn5QeaBb9/4g
         IhGrmMIJJ4Yf38HECTb8EHprI2QW7LAnbzmyvjTiz/0dIV5PgUCSlJJFZR87k6piCvuX
         RD8x/HrEOy9F4TfrPAzvUTPhVb6hTiLHPGmJDWiSLlInDj+nbINeQ4yxUaaByMcz19gv
         cVeA==
X-Gm-Message-State: AOJu0YylpVw/CeOYxxUv2W28W58iw4QgXmCW4JPEsC3aUQ2cOMRS+Bda
        SRBtTHqwSUCsSTLB87z2Cr8=
X-Google-Smtp-Source: AGHT+IEMg/Tnlu8eq0BMbhOEZDo19OPcdSvp2reFdXjF66hF1stq7Cv3VhULPpUY2sBAaCOfyGVFVg==
X-Received: by 2002:a05:600c:2206:b0:409:295:9c6e with SMTP id z6-20020a05600c220600b0040902959c6emr1557480wml.30.1698391917503;
        Fri, 27 Oct 2023 00:31:57 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-227.amazon.com. [54.240.197.227])
        by smtp.gmail.com with ESMTPSA id iv8-20020a05600c548800b003fefaf299b6sm929618wmb.38.2023.10.27.00.31.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 00:31:57 -0700 (PDT)
Message-ID: <72d847b6-1031-48fd-8155-1cd441f37f8e@gmail.com>
Date:   Fri, 27 Oct 2023 08:31:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 14/28] hw/xen: add get_frontend_path() method to
 XenDeviceClass
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
References: <20231025145042.627381-1-dwmw2@infradead.org>
 <20231025145042.627381-15-dwmw2@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20231025145042.627381-15-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/2023 15:50, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The primary Xen console is special. The guest's side is set up for it by
> the toolstack automatically and not by the standard PV init sequence.
> 
> Accordingly, its *frontend* doesn't appear in …/device/console/0 either;
> instead it appears under …/console in the guest's XenStore node.
> 
> To allow the Xen console driver to override the frontend path for the
> primary console, add a method to the XenDeviceClass which can be used
> instead of the standard xen_device_get_frontend_path()
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/xen/xen-bus.c         | 11 ++++++++++-
>   include/hw/xen/xen-bus.h |  2 ++
>   2 files changed, 12 insertions(+), 1 deletion(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

