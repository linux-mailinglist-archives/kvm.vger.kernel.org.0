Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B580437AC1
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 19:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbfFFRQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 13:16:54 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43041 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbfFFRQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 13:16:53 -0400
Received: by mail-wr1-f66.google.com with SMTP id r18so3235204wrm.10
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 10:16:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yhloh3JXP1tTNCG1mQUtazKoq6yMOHCszZ4yPDDzSnk=;
        b=V2wsUywLv6FdiSgysbuBmUmNe2a8h9xpm97/FRbLnoK5Pjj6uja9Bjq5k2/OGTmWNJ
         KxZUzCfbFLPuIX+E7E73GQZpPMlaN8mR1zDY4aRQXoKVeYnqBCs9upaAWgvmNTKATA+x
         kh5zfWxDt6RdL2FOqGF2ii0FOnO/SWtTGYE9Wf8WhCT8Wxy39/UpQ1NXi7kXnDYACEAo
         T/zwsWfkJgU8dS1H4XXjXHmu+A/zJjpr2ZpNn0C1cWwDZyVMuyX7cwG6xJe0kkkArZyB
         NqIl4niM6PWkeEsktgKXltQlKCr3FahXOGFnNwB1uMJeihJqdgtGEuMsuOueWAoJOtkU
         fWlg==
X-Gm-Message-State: APjAAAUcoSIiCvadgagxZvO+9jSEHFSZvS/EbMNkbo12jqrmcVS4kBCQ
        luamahUfGKw83l573Y4SYdcOGVpEVtc=
X-Google-Smtp-Source: APXvYqwRmEvuomPCqilpCr4j3UCDk0mNDsf/j1sNu5aRvgTY1yNCFDWO/HRSKwm2AScvqmXsL4a0Mw==
X-Received: by 2002:a5d:6243:: with SMTP id m3mr17985413wrv.41.1559841411958;
        Thu, 06 Jun 2019 10:16:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id 6sm2953827wrd.51.2019.06.06.10.16.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 10:16:51 -0700 (PDT)
Subject: Re: [PATCH 12/13] KVM: nVMX: Don't mark vmcs12 as dirty when L1
 writes pin controls
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
 <20190507191805.9932-13-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7facdeaf-a7c1-58d5-7057-f657a4397f07@redhat.com>
Date:   Thu, 6 Jun 2019 19:16:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507191805.9932-13-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 21:18, Sean Christopherson wrote:
> +			 * path of prepare_vmcs02.  Pin controls is an exception as
> +			 * writing pin controls doesn't affect KVM's dirty logic and
> +			 * the VMX_PREEMPTION_TIMER flag may be toggled frequently,
> +			 * but not frequently enough to justify shadowing.
>  			 */
> +		case PIN_BASED_VM_EXEC_CONTROL:
>  			break;

Hmm, is it really that bad to shadow it?

Paolo
