Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0301E5A1BA4
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 23:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244186AbiHYVvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 17:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243938AbiHYVut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 17:50:49 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32F537FB4;
        Thu, 25 Aug 2022 14:50:39 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id c16-20020a17090aa61000b001fb3286d9f7so6288102pjq.1;
        Thu, 25 Aug 2022 14:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=oY0tNLrjkd5YgY3aWBYHAk6kQ9OhNbI0PlnggsGRwxM=;
        b=apUXk2Vdt1u8UfuIzCKBlLkoMylgqryp2WcVDo2jJCbE0G7IuCr1QydUEXN4leDG7M
         rWaeO11jGuzEZddRu89jOIB5GC6vd4be5qKqm5Y3lOtP+O6vXj4nohPuPYc0UKbDXjKY
         xnDK9ulIHT1+996YDHtqCoh4Z9edaQy7t4Z4LV/wT1XlUbaWhCjJ0iusy0XZH/6SuNMC
         kdYkkMIzyU34ZXi9ny+13ajzcjKtMYmYaQlsVzTjANFM51KSw/ce9I7XJzori6cmb67v
         RGkwmj9lyFQJzlb8QoBEvEEIgCz3aUnCt/grk43AeEJHmJaT8uOjzI97l7ukzhTSDSIR
         FhVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=oY0tNLrjkd5YgY3aWBYHAk6kQ9OhNbI0PlnggsGRwxM=;
        b=q+XlKUmjiawrnh9NIk8zSK+9Zeb5FX7j9Z/tTeh2CGZdzMs9tQ5W+D/eUBKQSI0ir4
         EPRD1MzTtI2QeWBpLEau0wGlsNzD3Mtph8juU/4acx4UtQ2SCyXOHRRVmWa0oOB8uBHH
         taeMbS6qBd2bwJVLhs6/8qiy8JiCOz4Qc4rSmOkJ7BSQTnSbExmNdy8rkKwuSgZQL6zx
         Ex9WSQfb9M0ZALH98D4SPkm/PnXc3i2la5ylLzWteBwiFtYomuDqZRFG5gGFpIdBm2uN
         W79SeinEt6wnnqUlW8uB0AH8t9gs92VxbhsnPv28TgwEdxa6rodB1uvhSh9Hn1Q2jZQL
         UMAA==
X-Gm-Message-State: ACgBeo15kLGuwD2Qgx76I6yka7LY6xZXt2XMw+VYMnf4Z4shKCFSY2iJ
        28WiyXY5DIDY08zE81nV9dw=
X-Google-Smtp-Source: AA6agR6qzbjch6VtkC6HGZDhGdLInWEDI1F+Y8+raM9ySWmx4FObyOEuW9+Brs5t6bLDOjRDNc0XLw==
X-Received: by 2002:a17:902:cec7:b0:172:b20d:e666 with SMTP id d7-20020a170902cec700b00172b20de666mr881479plg.154.1661464239248;
        Thu, 25 Aug 2022 14:50:39 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id p7-20020a17090a348700b001f260b1954bsm216299pjb.13.2022.08.25.14.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 14:50:38 -0700 (PDT)
Date:   Thu, 25 Aug 2022 14:50:38 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 013/103] KVM: TDX: Define TDX architectural definitions
Message-ID: <20220825215038.GD2538772@ls.amr.corp.intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <f6bbcf4fb65a3de2ee7d4b2baa2965e24b0ede90.1659854790.git.isaku.yamahata@intel.com>
 <b19f28ac-07e0-2bd2-1b2e-abf7373b0960@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b19f28ac-07e0-2bd2-1b2e-abf7373b0960@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 11, 2022 at 11:15:07AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > +/* @field is any of enum tdx_guest_other_state */
> > +#define TDVPS_STATE(field)		BUILD_TDX_FIELD(17, (field))
> > +#define TDVPS_STATE_NON_ARCH(field)	BUILD_TDX_FIELD_NON_ARCH(17, (field))
> > +
> > +/* Management class fields */
> > +enum tdx_guest_management {
> 
> More accurate to use tdx_vcpu_management?

Thanks for pointing it out.  I cleaned up it as follows for more consitency
and better match with the TDX module.

/* Class code for TD */
#define TD_CLASS_EXECUTION_CONTROLS     17ULL

/* Class code for TDVPS */
#define TDVPS_CLASS_VMCS                0ULL
#define TDVPS_CLASS_GUEST_GPR           16ULL
#define TDVPS_CLASS_OTHER_GUEST         17ULL
#define TDVPS_CLASS_MANAGEMENT          32ULL

enum tdx_tdcs_execution_control {
        TD_TDCS_EXEC_TSC_OFFSET = 10,
};

/* @field is any of enum tdx_tdcs_execution_control */
#define TDCS_EXEC(field)                BUILD_TDX_FIELD(TD_CLASS_EXECUTION_CONTROLS, (field))

/* @field is the VMCS field encoding */
#define TDVPS_VMCS(field)               BUILD_TDX_FIELD(TDVPS_CLASS_VMCS, (field))

enum tdx_vcpu_guest_other_state {
        TD_VCPU_STATE_DETAILS_NON_ARCH = 0x100,
};

union tdx_vcpu_state_details {
        struct {
                u64 vmxip       : 1;
                u64 reserved    : 63;
        };
        u64 full;
};

/* @field is any of enum tdx_guest_other_state */
#define TDVPS_STATE(field)              BUILD_TDX_FIELD(TDVPS_CLASS_OTHER_GUEST, (field))
#define TDVPS_STATE_NON_ARCH(field)     BUILD_TDX_FIELD_NON_ARCH(TDVPS_CLASS_OTHER_GUEST, (field))

/* Management class fields */
enum tdx_vcpu_guest_management {
        TD_VCPU_PEND_NMI = 11,
};

/* @field is any of enum tdx_vcpu_guest_management */
#define TDVPS_MANAGEMENT(field)         BUILD_TDX_FIELD(TDVPS_CLASS_MANAGEMENT, (field))

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
