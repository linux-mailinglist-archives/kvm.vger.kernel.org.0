Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C459F728D1E
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 03:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237784AbjFIBdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 21:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjFIBdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 21:33:50 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A4A2D4F;
        Thu,  8 Jun 2023 18:33:49 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 5614622812f47-38e04d1b2b4so226183b6e.3;
        Thu, 08 Jun 2023 18:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686274429; x=1688866429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=054mTRUxEPdtrb7ivXoRErsU3vYGjbAVch0JPzI16Wk=;
        b=mzyv1nhSqrQtWMqZ19Pfy7kurBOadwl8rtQunFwidyCXYv6u8yxOzuoszSWeRTY41P
         emftQ91W0R5azu4U5di8nXjR9q4wyR6lZwIL5ETJ2ZuFttgs2PCsN3Ta2Fr+behXZ/I0
         zbAXi8+GTKq8MHROIs0qrna3vLTCLrUZiWavTasmVHKiiasrcB/jnyGCKYfDG8M6NJyv
         Et1hMRpKMB/RFn44WexRTr6foYRzN7tec51mgecJTQ6Fh6eF+IPnPvXc4sRiZPi15Cut
         yTYN8NiPej0aVRl/4IPFMbYKDTrE/Ao1jUks1TtguVr2uQhW5Ot3MIwZgua9aO8CL28T
         qW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686274429; x=1688866429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=054mTRUxEPdtrb7ivXoRErsU3vYGjbAVch0JPzI16Wk=;
        b=F6+aydbfLkcMdIlPt1xY3onWpcF/C2GFHQqvNEp1ea6YWECbjUmYhoEJ+yatwIQ727
         YhB0zasgd0etJuYEc8HpKv13izPkyukfCe40AHynLSjdslMvYv7IbxxZ+el+H9Bhti30
         Hqc9K1WMvDsU6QitspCtssPl6vXf8vDTs/rkKEQRlNGVv1Nse9hHpoVvmJtxwSECi7C9
         EvsD/nMSXjMiY7GGrzVoylCewUiPTXSaY58QlWdn0g5W0bkUdDZKhRAFP5ceSZh6qfXZ
         7r+CiFdMbThjqDM0HrG0EOvTFkv5NCnQThVh4pk5A/mVaxmLYW7T2KJMb2sGie2uu5P3
         QfOw==
X-Gm-Message-State: AC+VfDw4e91s+iwJIT+Yys89Tq097WSGUKJyF5arWszhOJ1nnBpg3hh/
        wCQkh7VJ4U7oNovw67Svoq1WZvlog/THyw==
X-Google-Smtp-Source: ACHHUZ5HjoLrjpzTTjoUo+3fEZdjMy55PDi3hyeMLhgBjbcTJJ3AEeKwuelkaJ7qFQypVgd48ix28w==
X-Received: by 2002:a05:6808:21a4:b0:398:36ac:44f1 with SMTP id be36-20020a05680821a400b0039836ac44f1mr269529oib.7.1686274428982;
        Thu, 08 Jun 2023 18:33:48 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id g16-20020a17090a7d1000b00259e553f59bsm2052031pjl.20.2023.06.08.18.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 18:33:48 -0700 (PDT)
Date:   Thu, 8 Jun 2023 18:33:46 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Message-ID: <20230609013346.GN2244082@ls.amr.corp.intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
 <20230608002725.xc25dantcwdxsuil@box.shutemov.name>
 <19ea7470e9d6fa698f9ad7caff3279873e530a0b.camel@intel.com>
 <20230608114128.vu75wlcojpyjak22@box.shutemov.name>
 <20230608232919.GM2244082@ls.amr.corp.intel.com>
 <20230608235441.olqpkrwzu2hplepa@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230608235441.olqpkrwzu2hplepa@box.shutemov.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 09, 2023 at 02:54:41AM +0300,
"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com> wrote:

> On Thu, Jun 08, 2023 at 04:29:19PM -0700, Isaku Yamahata wrote:
> > On Thu, Jun 08, 2023 at 02:41:28PM +0300,
> > "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com> wrote:
> > 
> > > On Thu, Jun 08, 2023 at 02:40:27AM +0000, Huang, Kai wrote:
> > > > On Thu, 2023-06-08 at 03:27 +0300, kirill.shutemov@linux.intel.com wrote:
> > > > > On Mon, Jun 05, 2023 at 02:27:21AM +1200, Kai Huang wrote:
> > > > > > For now both 'tdsysinfo_struct' and CMRs are only used during the module
> > > > > > initialization.  But because they are both relatively big, declare them
> > > > > > inside the module initialization function but as static variables.
> > > > > 
> > > > > This justification does not make sense to me. static variables will not be
> > > > > freed after function returned. They will still consume memory.
> > > > > 
> > > > > I think you need to allocate/free memory dynamically, if they are too big
> > > > > for stack.
> > > > 
> > > > 
> > > > I do need to keep tdsysinfo_struct as it will be used by KVM too.
> > > 
> > > Will you pass it down to KVM from this function? Will KVM use the struct
> > > after the function returns?
> > 
> > KVM needs tdsysinfo_struct to create guest TD.  It doesn't require
> > 1024-alignment.
> 
> How KVM gets it from here?

For now, TDX KVM patch series moves the tdsysinfo out of the function, and add
a getter function of it.
As long as KVM can access the info, it doesn't care how its memory is allocated.
static or dynamic.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
