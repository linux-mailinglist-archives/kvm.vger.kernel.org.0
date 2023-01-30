Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967FA680614
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 07:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbjA3GmB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 01:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjA3GmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 01:42:00 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323C111C;
        Sun, 29 Jan 2023 22:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675060919; x=1706596919;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VjLIbrqx+Ff2ABc64jc6qgSg6Ppq+n1wj8Bg1DjClLY=;
  b=kl4Jve7cupBO3sBjoHu9n2WHORkLLK8B2j7D5AO29w71ySQitC2g1pqs
   jTGwMB6mJeJ5UQFdadhjRtnHqMyqoMmmPb++kI+7Lkvg0jKU+uTZANGi4
   4S3R8Mwjrw5Tx9bhzTS42hpzMGTN4p2NgCcIetnCv69ZJLYa2TlaVRcwe
   +UOUqC4RYsmJOdcDDPrk0cMpdG06vfUYMI5ttBWwSIUGZXfyLZxmoCWqW
   r/M1RrjRHyFGylEj7jit0AFPjn3YMA1xWQq92+nakTxcskJwobij8x3OA
   DoQT1h0d+Lgai35KyqRJ7rC3qt0wMyAzdLl2ugUeFD0CCRd+yA8X9OQiL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="315444602"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="315444602"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2023 22:41:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="694459274"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="694459274"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 29 Jan 2023 22:41:58 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 29 Jan 2023 22:41:58 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 29 Jan 2023 22:41:58 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 29 Jan 2023 22:41:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/2QqWKnB3hpZpfhDGnntETR0ZUqb2CXXEXufRxQANIWu1Srk9FrP7z5WQGE13SOPsh3rR+fPOJM+tDKoF83YLL8VwKoKumO60UarylkE0N4qpiTZ1dZMaMOWIMugCnPWcphN2FziquKjkM6Zdof5Y/Fx1q4f44FYbiZS4ZrTruC316lw7cUKTMRGKqCt42RV7yMHA1qHEPMOzX5g0zvpaV4v+rEJlJl//MdXw6DxMz3wu1kBSw7NilrKIBgUAouNzziHuGDiQIYDILK4fR0o2GJjKmEGVRdks112S6DtjZcp0rGNndji16nBaROpJzvw63dDOqxFGCr4MK3fOe1VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kfVNtxvWb+Swzfkg2neKcJuDSYDL/UszZApo+o4VkY=;
 b=UnlfpxGpkymcoXHpjJPcV7e95WJ/t5cE7LXd9HaewPULF5bmQ8UNdgBi3ufNSrwMnlfrlBp41OO1glNXShfnpuvm0FwIfnhvBLU2b/AWuXB9h4iKnl9GwojTYZp+KOO7yTGVoUA+C6CjnJh4jYfVdOhoWmCsS666P+qUKuu4XF92esfVT0xCfX2CNdQUIiP7eRhgOHS7jx+kLWNzBO2y3ZzRs/QmSV5ZEru1F+Wvw8uu+6HIhGBdQqfL8/+InNakP347Syt9rCuo2bC1vAQhjfHAVJQaDoQI38hcqVNvxTUcqvN8SmLf63CIxMw1rlN3B0vm23MrBzOkbWWF9XrW3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by BL1PR11MB5238.namprd11.prod.outlook.com (2603:10b6:208:313::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 06:41:54 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::ba40:b444:6a6c:38ee]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::ba40:b444:6a6c:38ee%2]) with mapi id 15.20.6043.033; Mon, 30 Jan 2023
 06:41:54 +0000
Date:   Mon, 30 Jan 2023 14:42:09 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Kechen Lu <kechenl@nvidia.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <zhi.wang.linux@gmail.com>, <shaoqin.huang@intel.com>,
        <vkuznets@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v6 5/6] KVM: x86: add vCPU scoped toggling for
 disabled exits
Message-ID: <Y9dmwQNS1qufVwYZ@gao-cwp>
References: <20230121020738.2973-1-kechenl@nvidia.com>
 <20230121020738.2973-6-kechenl@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230121020738.2973-6-kechenl@nvidia.com>
X-ClientProxiedBy: SG2PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:3:17::15) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|BL1PR11MB5238:EE_
X-MS-Office365-Filtering-Correlation-Id: 3129ccdc-3542-4944-814c-08db028d13a7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 72BXMFLZogU4yMWOZJsyEP5vuGEINq6gAL3CZTlSTgxqOZ30oTzXK5qEnk2O4bI5onJuo5ea3mLQwjFkUSMzg7qAN2X7cwzTKTpGm5kJVt5654Al9ZYvQz+pURP0Z67WtaszL0A0j9l6XWRgXmt94TmriSE55X+D6ixV4HreHAbZQDVCQIfkPZhngUsARGpiq7a8Tozu/NY7Gh+aypzsSliSHSAkx6fWYO/rggZwO5lRn2elP13eHn9sao0vwukl5TNyXnF90eGfg+cwGaIMJPMxg3+qYD2DD+LQZ6MXXtTFCAFkfsno+V3ZwBDLlU08xof8VGuBQYrZflYT7t3AD2EMcqNuCnWM9T4CMhb+/rigSvyh9LZ8mVa6muOdyrWzDbAtW576BkljSJdbVdi+FT9Cih7r+L5Tnev0XC4oT3yDoQVyyoErWhxThfrWVYnkqkGvQF4JHb/ICviwP+z7mzwVndyXyNB/PkAjQWqCatLIZ01qbWJuP3cetOSVmSuc4LZm07ZEVhimWeb4x+bGQyFJghRh8NJpk5wh5ja0JFjGlFrz8J/dujwugsgbztlFoE4awjutusdyToWdfFONzYFZUJqlQ0jxmvjEb+u4t4BUW19WvvYPmAo3RCvbn40D9VW0e9ClKAPpZloX23gtew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199018)(316002)(66946007)(66476007)(8676002)(4326008)(66556008)(6916009)(8936002)(5660300002)(38100700002)(86362001)(82960400001)(41300700001)(6666004)(33716001)(9686003)(26005)(6506007)(6512007)(186003)(44832011)(2906002)(478600001)(6486002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oQ6LZ0cY7JG2VqNmKJpGx79HjCUEm22Xp5OTEPfydGCmgthhcjmhkrZtSaCP?=
 =?us-ascii?Q?SupdpWlEZAoa8NogyUnwLegF7yfe2hmHisQHp3iOsfjEFwODU15eNRnjhD2R?=
 =?us-ascii?Q?gu/+LpWNKVt+YKagd6RtYuqMUsn8tgvDW+8HOWyxpTX6daNNX3gmrYdl/YA2?=
 =?us-ascii?Q?R0Qf+rI/9KrW9Hbrjo0YjnIifrcWbWElzCDfdH8X8F0/3oXtCm2ynaJOYty6?=
 =?us-ascii?Q?Qvy4EM3m1G0JTw34ghboTO/t5QQ8idMlWJoBJk0+wBYHhEPRpL5x3+vI6iUf?=
 =?us-ascii?Q?83NFCZCjaBQC2Qzl5kn/abITcUWDysTSHkUBorMdbHGoqP/Ihp7AD5wKYFhm?=
 =?us-ascii?Q?fOcBoAWfrocSl8uAg29vpp7RP9af0fxiKajY+vZ+7JIv9MdO7l55dhJ++bld?=
 =?us-ascii?Q?n+JhfaJrBi39ssNlcTXUimfeqoxz4o1yeankri7tUQFuMkSNICaRzifklNUu?=
 =?us-ascii?Q?5QB279B52d9kZP0mzBCyQfOR9OaWs9gn4lO1Rx9H58SqqV0k4DQ1Fkd/z+vs?=
 =?us-ascii?Q?RM5nTUWIJMxWKaAaGi5ZxqkxtOg/ImwI46e86eA6Vj8+EMXlo4fa4a+0sS34?=
 =?us-ascii?Q?vpcrEBUcGhwKeEa8Z77tHF9XWxY3xZKmtwTMAnyCVNUmB2bBh7wMYIESv9XF?=
 =?us-ascii?Q?WHpMqpONeEU+YNVdjor/JJXxLlwnzK9890eRQOuN4gcXtoRJKb2w+M9vbKLH?=
 =?us-ascii?Q?aQpshKPt8ZdX2FJL11GKWHr2YLN1uJM08ntwVP2xHFU7JROHAUCI/0fulgQm?=
 =?us-ascii?Q?k7dPMunL2Iol+HdN0eBZAZg7uenGuJS253uTTBpgXRGNUoMD3vVKBvEcEWWv?=
 =?us-ascii?Q?FeDwgQgcjVWegyWufhww2GQsvXwgnBo6v5Ue2/9t1TnGJkToPNcaAbvzde/r?=
 =?us-ascii?Q?Xu6AjFFqNNbsF9r2aSqwvCvsalFJyOqWWUn2C2RYFqZgZANY3xLdlMXyyKHs?=
 =?us-ascii?Q?C3U/mK/56xc35TzHGUiKDFt60l3X8NzzXNL8hFtcpaSxyEhkd31HRMZDV6pb?=
 =?us-ascii?Q?PlhlazYaKKkb5S6ocfOF0ApVuZYPaie2SiaRo4A+SFYw+PguyCN09O/h8KAq?=
 =?us-ascii?Q?+gDpsrBpocU/LL5DZ+nuXfJq6o/R5W2UbmW7yyvX8qgfZlus2xPA/nF7UQ8u?=
 =?us-ascii?Q?e2VS2/Jo+whnxAhPbEYxJO4/hDx7GI9FW3kz4xk1TyCRFmFzwVQfhcAjw1RE?=
 =?us-ascii?Q?S1EOYad+adjh34sb3UZOk0UDkwsit3xhxFmjA+KIuKFvCUfcmZNSriftmQDc?=
 =?us-ascii?Q?4aGxL9vseEGLwcXapiPwaeiRA6M3WrDRstp4jpv+Ms+qme5MGbfXVUUuJ5gM?=
 =?us-ascii?Q?pQJBk2XnoU8XNP9xWFjhL7pw49rg9jbD2T/DnINKj/0MChYOPFUDMZnUvto3?=
 =?us-ascii?Q?sBO54tsoYYwdpvFh0Eks/aePgt+1lx7+CY+RtFppPQ/nK0/nl97v8xpEgYKe?=
 =?us-ascii?Q?hoIx2d8yPDeMJZdVuhXOa3BI5qPTQGohRkD+emBF1U3/yJZRfWvucSkiiv4y?=
 =?us-ascii?Q?QWkNdOfr6UyyxatYqf1tBFkReA6aCTEkXP4mLt5GQvyjhj8vTi14Jtoz8kkG?=
 =?us-ascii?Q?A3hNrBzhcDzkCyh+duhpXOB4Ml//KmDnCvRS6gqB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3129ccdc-3542-4944-814c-08db028d13a7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 06:41:54.7708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HjLLqR+b8YtUjPZK70MrXoKgC1jd+ZQ3PKXxKGIXVZ6SCWnZtoR80swIsoCqNeDY8lQSZbGp5XWbKq+gC5y1Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5238
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 21, 2023 at 02:07:37AM +0000, Kechen Lu wrote:
>+static void svm_update_disabled_exits(struct kvm_vcpu *vcpu)

Is it possible to call this function on vCPU creation, i.e., consolidate
initialization and runtime toggling?

>+{
>+	struct vcpu_svm *svm = to_svm(vcpu);
>+	struct vmcb_control_area *control = &svm->vmcb->control;
>+
>+	if (kvm_hlt_in_guest(vcpu))
>+		svm_clr_intercept(svm, INTERCEPT_HLT);
>+	else
>+		svm_set_intercept(svm, INTERCEPT_HLT);
>+
>+	if (kvm_mwait_in_guest(vcpu)) {
>+		svm_clr_intercept(svm, INTERCEPT_MONITOR);
>+		svm_clr_intercept(svm, INTERCEPT_MWAIT);
>+	} else {
>+		svm_set_intercept(svm, INTERCEPT_MONITOR);
>+		svm_set_intercept(svm, INTERCEPT_MWAIT);
>+	}
>+
>+	if (kvm_pause_in_guest(vcpu)) {
>+		svm_clr_intercept(svm, INTERCEPT_PAUSE);
>+	} else {
>+		control->pause_filter_count = pause_filter_count;
>+		if (pause_filter_thresh)
>+			control->pause_filter_thresh = pause_filter_thresh;
>+	}
>+}
>+
> static void svm_vm_destroy(struct kvm *kvm)
> {
> 	avic_vm_destroy(kvm);
>@@ -4825,7 +4852,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> 	.complete_emulated_msr = svm_complete_emulated_msr,
> 
> 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
>+
> 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
>+
>+	.update_disabled_exits = svm_update_disabled_exits,
> };
> 
> /*
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 019a20029878..f5137afdd424 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -8070,6 +8070,41 @@ static void vmx_vm_destroy(struct kvm *kvm)
> 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
> }
> 
>+static void vmx_update_disabled_exits(struct kvm_vcpu *vcpu)

ditto.
