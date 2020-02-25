Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD2A16C3BE
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 15:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbgBYOVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 09:21:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26993 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730569AbgBYOVu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 09:21:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582640509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l8zoVfuT97QhV/VrbWfZXqBtdN1Hpx5Lgx8cGxD0214=;
        b=ix05neEgiOANOTDrevZHBDEMHfhWsudO/kL62bYZPzOF/MgOWJfA0RR0WEFvgCL7nhQNY0
        7cPafWtE/zaCVvp5XKg6Xc2Sqfz28G17yQ85HkRPivxf0vWx55TqMkzOLpzCjg5o86kdFC
        Ik4EQPi3x9IDf9FZwsBGCBxb3aOOgY4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-bYhUFWfMOhGcf8SrabpeaQ-1; Tue, 25 Feb 2020 09:21:47 -0500
X-MC-Unique: bYhUFWfMOhGcf8SrabpeaQ-1
Received: by mail-wm1-f70.google.com with SMTP id y7so930756wmd.4
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 06:21:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l8zoVfuT97QhV/VrbWfZXqBtdN1Hpx5Lgx8cGxD0214=;
        b=XExYKmyU936/E7+AO1e6KxE9C5/tVzmLnwOA7NoIn4GleR6MAgqzVXtJeWLo6GQTmb
         mlTXMAtZ0juE4bbaCEgc48kpgC3j3P64EGUjUZRLauDAANYHV3ACfu8GPgoApNYuZhn1
         MJ5IE04FkH2dFobzUAqg2q0O1nh7xdH3FUONW8nXNWHXf44bTqWaSZ1tK+A1wfcA/aUm
         qCC/H70wH3oagMMK5HbiMJDmBfFox5Gpt+2m3VI8Ku/1MCIsvuno7XYXy+VS6/b/qlFP
         hohpITuCD7TG+xgr+yu3wXLSYwbT6xp6IMhNHDZl0AW1pwC7qa5ACYwQvJFoEA8oyULY
         5FMw==
X-Gm-Message-State: APjAAAVbIdb3JoxW0XGxTl0pNKze4oVKUQOK7MEIQOil3l9iTPQsh3qC
        FLV4CRryDToysUgTMzlZLnR89gLvx/mBADeH8+Gjc3vVzOJzXcO7j1ytkbHTlJFRbxR72i5h2PN
        SisuaKhPwgyKV
X-Received: by 2002:a5d:528e:: with SMTP id c14mr74571606wrv.308.1582640506064;
        Tue, 25 Feb 2020 06:21:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqwslpdVPtjbpEmq1sL3K0sJ92R01Ra27DqDcfEldCfb+so8/yvNfB3iDQYMdvtt1pMPJ7jqAA==
X-Received: by 2002:a5d:528e:: with SMTP id c14mr74571576wrv.308.1582640505811;
        Tue, 25 Feb 2020 06:21:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:3577:1cfe:d98a:5fb6? ([2001:b07:6468:f312:3577:1cfe:d98a:5fb6])
        by smtp.gmail.com with ESMTPSA id g7sm24714487wrq.21.2020.02.25.06.21.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 06:21:45 -0800 (PST)
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        jmattson@google.com, namit@vmware.com,
        sean.j.christopherson@intel.com,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <9cb2dbed-356d-31cd-22aa-fa99beada9f7@redhat.com>
 <CA+G9fYuTNr3YrehjuQD=nCXhdrirxGaiNEVMS+mHcM0fGVigVQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fec48277-5f42-8f2d-288c-2b8591c33bee@redhat.com>
Date:   Tue, 25 Feb 2020 15:21:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CA+G9fYuTNr3YrehjuQD=nCXhdrirxGaiNEVMS+mHcM0fGVigVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/02/20 10:55, Naresh Kamboju wrote:
> Running latest kvm-unit-tests on x86_64 got this output [1].
> "VMX enabled and locked by BIOS"
> We will enable on our BIOS and re-run these tests.

The message is saying it is already enabled; you don't have to do anything.

Paolo

