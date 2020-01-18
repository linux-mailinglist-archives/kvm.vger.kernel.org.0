Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93423141953
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 21:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgARUDH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 15:03:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44309 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726822AbgARUDH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jan 2020 15:03:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579377786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ffd+kZMGJK3EtC4IWqohC6rZpO0y8vICQx285ikZQIw=;
        b=OlPhWrbAi52oro847rFlwIMd8d1jCzExwnQmkfjD6JVrPQCR9ZZbDeLQgwBXWHnkbFkR82
        ZKYei6UqWAlH8muGi/65a5tZblkyiy8tJ3Yo6ac1iRXMqJ+Ly7jMxe6nZVgYKmzp0jIwsP
        tx/uQlqPbPubSEiLb9vgod3yrpSaH6w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-ZLczs06ENPS8xKnvbXT4Zg-1; Sat, 18 Jan 2020 15:03:02 -0500
X-MC-Unique: ZLczs06ENPS8xKnvbXT4Zg-1
Received: by mail-wm1-f69.google.com with SMTP id t17so1625426wmi.7
        for <kvm@vger.kernel.org>; Sat, 18 Jan 2020 12:03:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ffd+kZMGJK3EtC4IWqohC6rZpO0y8vICQx285ikZQIw=;
        b=oBcmGPslvKxxBgJXINvVSvEg6dG95qxeFL1k5CfIzfr2LxNWG0w/TAnTrtssr7R7sJ
         D6izJq6CeHYJUHpyWfAcLnKKbtWmemUu00JSbNvm6X1zzEjfdjpZotTsJAnGWdtKkEj6
         wG+AzGcvDr9M/3XdWGdkHk1Tv54wQECYTVPHef5UpMrjUSmVOvsSJI1ZSM+oTJBDTx83
         DvetzaTAvhOlcWt6ig9xt0hRHrxgd9SYDQUpLl2rJlXqqwhhGesz4wM54E5JsZKHgWwQ
         vj8wGwZF+QtArQtgUd/uuocHKUoStoOszTr3w7m5cW859oGXkcGMSf4bacu5Ho5qrb9C
         TtoA==
X-Gm-Message-State: APjAAAXi4fp1jmbCTXkC6vURX9tLkj+lxdBBUo67SquzSMhYL2ZE+x0j
        g2uqdK4cw0vwzAl5RrHhyiI9stasWmozgni1SJYtEyV47k+AEAjtgWmBU1iNP5XYrzDt2aLO66B
        dx4urC8v2nLy9
X-Received: by 2002:a7b:c764:: with SMTP id x4mr10954453wmk.116.1579377781004;
        Sat, 18 Jan 2020 12:03:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqzDsQSRZgQ6mbHT6GTIa0SMy65kQ4RAJn7N9yOxqTsF/9/ZO5K6Pt7ZnzQpzBr/FAxjD5bo6w==
X-Received: by 2002:a7b:c764:: with SMTP id x4mr10954440wmk.116.1579377780802;
        Sat, 18 Jan 2020 12:03:00 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id f1sm15135006wmc.45.2020.01.18.12.03.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 12:03:00 -0800 (PST)
Subject: Re: [PATCH v2] kvm/svm: PKU not currently supported
To:     John Allen <john.allen@amd.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, vkuznets@redhat.com
References: <20191219201759.21860-1-john.allen@amd.com>
 <20191219203214.GC6439@linux.intel.com>
 <8a77e3b9-049e-e622-9332-9bebb829bc3d@redhat.com>
 <20191223152102.7wy5fxmxhkpooa7y@mojo.amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2538c462-7eb7-3357-1ce9-ef26ad267812@redhat.com>
Date:   Sat, 18 Jan 2020 21:03:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191223152102.7wy5fxmxhkpooa7y@mojo.amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/12/19 16:21, John Allen wrote:
> Hey Paolo,
> 
> If you haven't already applied this, would it be too much trouble to add a
> fixes tag? If it's already applied, don't worry about it.
> 
> ...
> Fixes: 0556cbdc2fbc ("x86/pkeys: Don't check if PKRU is zero before writing it")

Done, thanks.

Paolo

