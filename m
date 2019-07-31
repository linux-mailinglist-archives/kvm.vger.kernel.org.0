Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6CB27C2A2
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 15:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbfGaNCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 09:02:21 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44044 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfGaNCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 09:02:20 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so69572706wrf.11
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 06:02:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OrhRm6hcm8XAS5rJURO8NQ/9XsfNWDSC5tHBQHcDz/M=;
        b=AEGsukuKBK7iPDDbLoBBmiEZKf6Ai5xUVivOvPsjD26vLTniv7Qa098d7fyeAT47RL
         fcm/zGUQElscAOMY7asKHz4tWrULX/BfFkXt/3/vNLcdXxfHkb+hJACxmr2o8SOjkmm9
         QGixLmnFncCzC6b7Qz94nci/Gk34VSpzy45rwGLuLMppXx+oFoaUqCEX1CBnaQFFdbOq
         CkEufdJRGT6yfBuOuUv4tzBPAl5eWnz4R5Ih8a3VhxgxKsPqOxjIXGoJZTaRKmMOCxdr
         EoQX2axFTHTGlIPw/E39bt6TZTd2XbPkyfl/WJZVkpskoPoU36VYBY0S4uPKjm37x/P5
         K1gA==
X-Gm-Message-State: APjAAAXENpY1PhReASQopGap4KfhoDH2k67BHpCHFnZMEu6ucpZmj0R+
        KuL6In2hCIkz/CImcBhqm4T+Xg==
X-Google-Smtp-Source: APXvYqxf6pEx9kjzhl6+ziNUinxsA8XNUQEe22hXvk6qWrgDyW26ihoHLEH5Brf5eo9dygInUHQbJA==
X-Received: by 2002:a5d:6ccd:: with SMTP id c13mr132842592wrc.4.1564578138595;
        Wed, 31 Jul 2019 06:02:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91e7:65e:d8cd:fdb3? ([2001:b07:6468:f312:91e7:65e:d8cd:fdb3])
        by smtp.gmail.com with ESMTPSA id z7sm66068294wrh.67.2019.07.31.06.02.17
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 06:02:18 -0700 (PDT)
Subject: Re: [PATCH] selftests: kvm: Adding config fragments
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, drjones@redhat.com,
        sean.j.christopherson@intel.com
References: <20190731105540.28962-1-naresh.kamboju@linaro.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <43fd5a9b-7ecd-3fff-2381-1dfce7b8618a@redhat.com>
Date:   Wed, 31 Jul 2019 15:02:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190731105540.28962-1-naresh.kamboju@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/19 12:55, Naresh Kamboju wrote:
> selftests kvm test cases need pre-required kernel configs for the test
> to get pass.
> 
> Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Most of these are selected by other items.  CONFIG_KVM should be enough
on ARM and s390 but MIPS, x86 and PPC may also need to select the
specific "flavors" (for example Intel/AMD for x86).

How are these used?  Are they used to build a kernel, or to check that
an existing kernel supports virtualization?

Paolo

> +CONFIG_KVM=y
> +CONFIG_VHOST_NET=y
> +CONFIG_VHOST=y
> +CONFIG_VHOST_CROSS_ENDIAN_LEGACY=y
> +CONFIG_USER_RETURN_NOTIFIER=y
> +CONFIG_PREEMPT_NOTIFIERS=y
> +CONFIG_TRANSPARENT_HUGEPAGE=y
> +CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> +CONFIG_THP_SWAP=y
> +CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
> +CONFIG_IRQ_BYPASS_MANAGER=y
> +CONFIG_XARRAY_MULTI=y
> 

