Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FF04230C0
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 21:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbhJET3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 15:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhJET3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 15:29:13 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E557AC061749
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 12:27:22 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id t8so981585wri.1
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 12:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gjGbZQFATwhF+BES3nhgMC8T008nZ3OInRqvg+24qlo=;
        b=UrohL+upv4vlrkwkvaFauYBW9yeI+t5LBdA74nxK6EUFBjQFfxSjZESHmsOL9VLdQQ
         m9syZF7vkkjdVm/nDeF/BYFoXmCpb1sMrewykOtb/hEFj29x4/Kg2VMLREKcpAHYTn1C
         74avyLnpMeYxn0pNnZD6ffe71lVglJSgko83XgSyKjJAD4Ycl3ysLSiNEOvqh6JIMZh/
         FZhEHGg+lieSd4QLk3BGoHv3u/H2U2F2NQXLaiaqdIf+Bk4iYz0di7QqP8GemttuUgi5
         KcMMNOVowG5GuyXgbmmPs6JVTYqcPZg8JClLX58HPyuXDSYm2+v1nlMlrscpSL7VcPMP
         9ngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gjGbZQFATwhF+BES3nhgMC8T008nZ3OInRqvg+24qlo=;
        b=3Uo5Z0UbI+z3p1qidIm7+L43DOE07kIRooeE+jKtwI/VGReWQ7N5KIh4fjsqg+AvTA
         RxAoolnue1r4IYaevOOELe3/QCLL+UqWurzYrVnKBdN+MkeJrqbyGAlQM8m4+ong5N9b
         PpplEmo/VlTSChnJWSi3EuA5R2DPsBK5JCjF316z25BfoJlovq0fi+mgWOPd1Jp9EKHN
         mATQlwe9WLX0JwiyVyRMy1GcHoK5+WY4JW9OIb6sn9IAoZg0cBAxrLtNK9gJcEe8iKxj
         nJGcoHd16ds1Hg38J9mdaSGK0qDaYIjYLMWSWXdE8E75kWxi9Ixqbjw26aK4UsXNvmr4
         Z2jQ==
X-Gm-Message-State: AOAM531lqH4ry2LBDznaSEnCF4msE3N3WCQoZ8YR2IJvGiuObwEyKNLi
        oyWTSBT+8R8oX/oWnT5iluI=
X-Google-Smtp-Source: ABdhPJxGvGzHYlon9ExqeHoSmKdWMwW1h9D3Y2v58vJK0sc8Pe5g8O3IcFEmry7YN9RlXZA+NbsL0A==
X-Received: by 2002:a1c:4484:: with SMTP id r126mr5381571wma.150.1633462041536;
        Tue, 05 Oct 2021 12:27:21 -0700 (PDT)
Received: from [192.168.1.36] (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id p18sm7312497wrt.96.2021.10.05.12.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 12:27:20 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Message-ID: <79bc4067-1ed0-0b06-e847-2875c75ffb9f@amsat.org>
Date:   Tue, 5 Oct 2021 21:27:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3] target/i386: Include 'hw/i386/apic.h' locally
Content-Language: en-US
To:     Laurent Vivier <laurent@vivier.eu>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        qemu-trivial@nongnu.org, haxm-team@intel.com,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Cameron Esfahani <dirty@apple.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Colin Xu <colin.xu@intel.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Wenchao Wang <wenchao.wang@intel.com>
References: <20210929163124.2523413-1-f4bug@amsat.org>
 <20211005105745-mutt-send-email-mst@kernel.org>
 <fb4d7f19-8bb5-781d-4a41-9641625a2019@vivier.eu>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
In-Reply-To: <fb4d7f19-8bb5-781d-4a41-9641625a2019@vivier.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/21 18:45, Laurent Vivier wrote:
> Le 05/10/2021 à 16:57, Michael S. Tsirkin a écrit :
>> On Wed, Sep 29, 2021 at 06:31:24PM +0200, Philippe Mathieu-Daudé wrote:
>>> Instead of including a sysemu-specific header in "cpu.h"
>>> (which is shared with user-mode emulations), include it
>>> locally when required.
>>>
>>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>>
>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>
>> which tree? trivial I guess?
> 
> Yes, but for me the patch was not correct because there is no need to update target/i386/cpu-dump.c
> But perhaps I misunderstood the answer from Philippe?

You understood correctly, this series requires a respin.
