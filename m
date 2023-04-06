Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E483E6DA614
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 01:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238839AbjDFXJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 19:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjDFXJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 19:09:11 -0400
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 06 Apr 2023 16:09:10 PDT
Received: from esa2.hc3370-68.iphmx.com (esa2.hc3370-68.iphmx.com [216.71.145.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627135277
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 16:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1680822550;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5X3yHSNUIUwXa/Ha5P+eWis7MsmcbLEkUlqspqtxLYc=;
  b=QugkYkFh99T7YuQbXpOIaN2+kMmWvuHH2H8OSmpjk7V2ToGkVu2FB1ts
   3vqTHzrS0DEK2drx7aNzyh82FBqljT7rWRIA7MrPwzHxuS6x1Eup6nsfJ
   rxSAyTmHh92dXtlOtUjm2l8wdOC5IpqW1UUyrES2c5H5bFlaiM5SUV0y9
   Y=;
X-IronPort-RemoteIP: 104.47.70.107
X-IronPort-MID: 104544254
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:0For3q1+1mSfqW5qsPbD5fd3kn2cJEfYwER7XKvMYLTBsI5bpzJTy
 2cbDWiDOa2JajfyfN0lb4vlp00PsJPWm9JrQVE/pC1hF35El5HIVI+TRqvS04F+DeWYFR46s
 J9OAjXkBJppJpMJjk71atANlVEliefTAOK6ULWeUsxIbVcMYD87jh5+kPIOjIdtgNyoayuAo
 tq3qMDEULOf82cc3lk8tuTS+HuDgNyo4GlD5gBmO6gQ1LPjvyJ94Kw3dPnZw0TQGuG4LsbiL
 87fwbew+H/u/htFIrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRrukoPD9IOaF8/ttm8t4sZJ
 OOhF3CHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqFvnrSFL/hGVSkL0YMkFulfHkZL0
 tAYMhI2bS+jjsypmY+gFPQwmZF2RCXrFNt3VnBI6xj8VK5ja7acBqLA6JlfwSs6gd1IEbDGf
 c0FZDFzbRPGJRpSJlMQD5F4l+Ct7pX9W2QA9BTJ+uxouy6KlFMZPLvFabI5fvSjQ8lPk1nej
 WXB52njWTkRNcCFyCrD+XWp7gPKtXqjBN9OSOflqpaGhnWD7FYVLzwxd2CmpOmB2l6OS/dSO
 1Q9r39GQa8asRbDosPGdwW1vHOerDYdXdRKGuE34Q3LzbDbiy6aAHMNUj5QYfQludUwSDhs0
 UWG9/v1AiZxubmZUlqZ97GJvXa8PjUTIWYeZCgCCwwf7LHLpZovkxTCVf59FbG8lNCzEjb1q
 xiDtyg5hPMJhMwj1qOn8FSBiDWpzrDSQwcz5A7/UWWi4Qd0IoWiYuSA9Vff/d5ELYCEUkOGu
 nkU3cSThMgSDZaInTfLROgLELii5OetOTjQx1VoGvEJ6zOr6jinYItTyDB4OEptdM0DfFfBY
 1HWkR1e6YUVP3awa6JzJYWrBKwCyanmCMSgXfffafJKY4Ntb0mD/SdzdQic0n6FuFh8z4k8N
 I2dfMLqCmwVYYxizTy5QM8H3LMrzzx4zmTWLbjx1zyu1buTYi7TRbptGFeHcO1/7KqCuwjT2
 9JeMdaajRRZTOD6JCLQ9OY7LUgDBWoqGZfs7cdQc4arIQt8GWUlTeTR3K8sfot7t6BUkPrYu
 HC7RkJcjlH4gBXvKgiHcXtkb7DHVpZlqnc6IClqOkyns1Ahbpyo97w3bIYscP8s8+kL5fxzV
 f4tK8+RHvlUDDPd9Fw1b5j0qoN5dB2tgQuPFyWgaTk7OZVnQmTh/t7iYxuq9yQUCCezndUxr
 qfm1Q7BR5cHAQN4A67+avOmyVyqvXEb3uZwRGPBJMVcYkLx6M5hLCmZpv8vKukIKBPe1n2b0
 RqbBVETouyli4Y22N3Ig72U6YavD+Z6WEFdGgHz6auqMgHZ83ClzIsGV/yHFRjUT2LovqbkY
 OxRy/D3M9UGmkpHt8x3FLMD5aAm4NrqrbhX5gdpBnPGaxKsELwICnKI3NNnuapKybtU/wCxX
 yqn9tBENPOJMcX+HVg5JQw5Y+DF3vYR8hH+5Oo0LAPZ7Tdz9byvWEBeeRKLjUR1Nrp4Np8nz
 PwJt8kR5AiyzBEtN76ugiFO9GSMBmIFTKw9u9cRB4qDogcxxlxHaJ/AAzTe75aIZNFBdEItJ
 1e8hqPEwbdd3VjBelIoFHXI0OxGw58JvXhizkQGLl6YssHYnfJx1w852Tg+SEJXiApG1+ZyM
 21wH0xzOaiKuTxvgaBrVnqqFylIHhuV8Ar9xjM0eHbxSkCpUinHKjI7MOPUpEQBqTsEIX5c4
 a2Sz3vjXXDyZsbt0yAuWElj7fv+Udh28Q6Ek8eidyiYI6QHjfPeqvfGTQI1R9HPWKvdWGWvS
 TFWwdtN
IronPort-HdrOrdr: A9a23:Pv8Nra2TdSKags57lSjyHQqjBfdyeYIsimQD101hICG9E/bo4v
 xG+c5xuyMc5wxwZJheo6H9BEDtexLhHP1OkPos1MmZLWvbUQKTRekJ0WKI+UyCJ8SRzJ856U
 9qG5IOd+EZZTJB4foTi2ODfOrJD7O8nZyAtKPm6zNIcCkvUqdn6m5Ce3Sm+o8dfng5OXL8fq
 DslvauYlCbCAUqh7+Adx04dtmGncTPiJXlJTYeHnccmXCzpALt0qf+Dx+bmjwDUzZDqI1SjF
 TtokjC/6C+tPP+7RfZ2wbonvNrseqk8MJHGMuPzu4KLTn24zzYArhJavm5pTUop+Pq0nYG+e
 O82ysIDoBI8nbMeWPwmxf3xAX69z4r5xbZuCSlqEqmm9X9WDU5T/VMnphYdByx0TtbgO1B
X-IronPort-AV: E=Sophos;i="5.98,324,1673931600"; 
   d="scan'208";a="104544254"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Apr 2023 19:08:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYPpElm32Rg7Kc0ADsHmDApqBtgKjHNHQstu06noBVmsKvxIWhkfcg7ysyOebeJ+M/Qk/cI+1txta5pjLNWmqXH4Hil9y5lIulUfswn0bEwW5RwSEUtrl8GHG45DvLlfcVSy0EB8do8LtVEBkx2me8Um0/K/NlIR8AwKWT3yfT5o5Qi+twb6Mhqi0nAlTw9fPS65wtgobkvXGmN+qitu3XRvNAp8I00alZ4iUAQAIqX9PxfRVlVXtZGPl3AfzouHEUYMoDrSRHr0axUrJ3le5Akiwe6OxBK+PrTa97+YHrwOOzLrCNm0u4x3i8N3jzcJorZYHODJ39gYMYSdB5leUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=27+kZzDOSktww0PamJmWsKjKxDy+Hsx6xfmwnM8lNUc=;
 b=JEK3DPfLgYRT7Y4+YSVTCKTiUYfK8Dgy02Vq8HplNa3tWxfGbsGou/oLHfCY7mELPldrctbp8mcE/rkT9E5BtKIT3W00WmDMdys2Ab+1PraKIsgpJ7H0FSi4L3NhEtYUqUln63k+uhxneufq0gATyUqThKKhID1oWS4d93JTvHaFYNX3yalEnC8nJGO0yfGsiCOgFGmNMWtFYRfZx/C1XocmINELitpPtXnh6qXsYVoAxaF85r2BgSJUtOljnRAbeEZhl+/eiZMA+EvjFlU6d5JSkRzjs2OjzpDKCN6tFQwTJMHXpcWrSCcLTfjF/BXVzY2VE5jau3Hgv2dUqo+cow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=27+kZzDOSktww0PamJmWsKjKxDy+Hsx6xfmwnM8lNUc=;
 b=dvETz9szgcTRvJk4Ab5xv2q1pHhA1lDlMDNNGnbUQBONG+udIQUoZX5O4p0KXmdAlyAiqsIsjlaZItKIAUl/IBfPx9CzQFkyCNi+DESJGE6vII/Ikj4TTsgDPVLlsDUQTZinOd6fGSLSOHOX1YiWncLfvfq1Bi28O2AekeXM5Fw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by SJ0PR03MB5952.namprd03.prod.outlook.com (2603:10b6:a03:2d8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Thu, 6 Apr
 2023 23:07:57 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::a5a1:8cae:d45b:2030]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::a5a1:8cae:d45b:2030%3]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 23:07:57 +0000
Message-ID: <dd649741-297a-eb36-eec9-7d1b52d18b7d@citrix.com>
Date:   Fri, 7 Apr 2023 00:07:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [RFC PATCH 3/7] x86/entry: Implement atomic-IST-entry
Content-Language: en-GB
To:     Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Dirk Hohndel <dirkhh@vmware.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jiri Slaby <jslaby@suse.cz>, Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
 <20230403140605.540512-4-jiangshanlai@gmail.com>
 <20230406215843.GH405948@hirez.programming.kicks-ass.net>
In-Reply-To: <20230406215843.GH405948@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LNXP265CA0088.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::28) To BYAPR03MB3623.namprd03.prod.outlook.com
 (2603:10b6:a02:aa::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB3623:EE_|SJ0PR03MB5952:EE_
X-MS-Office365-Filtering-Correlation-Id: 767b487c-ad9f-4bdb-44b6-08db36f3c25b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lB+dVO6OTuCFYTmvyvPQfvS2cdMGuiIfyTShJHqpTbKrB7mR0qhjaBljCqByVF6GJRzeYhgALv45zQk0n3qiJdtLHWc5yMiCehdkQnKQ3JreyyPQr8gabIyyU9/onFJin7qJmO1NOYfDNtBJcFCVpw4LzHTY86ZYUEMsqnozAxEk8OIUb547M1kh/WokZE0hq86C/oaF1Yd0jqaEDQ9tEN3Wqo5+3zK/oUUaBMfJTahBaU6bujSTJMZ1lt6HE09Tcjxj4fu+UtH3CGS6Kcs27AtYFQVbWOp7w46+QkTFFsXlS/eBRC+HlD3yepKqmuKY5TASTFtWWJ65J0kcvzQ9yFtP9V0eqIfHQKgv+9OTBTzI7ZftWS0VOjX1Q75W45uCHqgqCYmSSHNgrOvKwGmvMrZIotdHR7UucD/e3LGKGk3kuixrXzZcMVIaWkcViaJlam4o0adAU/g3FsOOm1mtA7s2kGaZDC5PHl5CILSu/gBJIqWYhzSN1JVmWC4qk/YZVI1oDLgW8LjhrrXVM/VCuSDIGEpVBCAfhBvBU5PO2xpMdvNuWjSA7SPn+jjARn5DkDYM+kbjBU4PvJ0DPFlFSF/Anb/PeiyCQbzARDzEQ5WNO31857KDlMguN9cY1viZ4PDrxvx0PC+gtnDfiwHTKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(346002)(366004)(136003)(451199021)(31686004)(36756003)(4326008)(38100700002)(7406005)(5660300002)(2906002)(31696002)(7416002)(8936002)(8676002)(41300700001)(66946007)(66556008)(66476007)(86362001)(82960400001)(6486002)(2616005)(110136005)(6506007)(478600001)(54906003)(53546011)(966005)(316002)(6512007)(26005)(186003)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjU1ay8xUnAwT3k2WEFoNjlDMzcvQ1pFTDU2alJuMURzdTU1MWdIVm5PWUs3?=
 =?utf-8?B?TkVsdGZFekNOMGdYd3FBNXl4ZFNnTlhLU2N4V29YOXBkWDU3QjlqYktvc1hm?=
 =?utf-8?B?dzF4SXhHbThhTWlmRTFJT3FEWVg1NFZhVEFzTTYrT2dqZE5tYzE1WXpKV2k1?=
 =?utf-8?B?YXZOZmlQN3p1b2F3UWhyTFh2aHFiVGtKTUUvZW13WmZuajA0VEVDbFl4bkVD?=
 =?utf-8?B?VW1XZjdzRDdZUmduTjNzWVhVWllVWDM2dGIvSWZNc09oM1hxRkEwYnk2aytP?=
 =?utf-8?B?bVlSUkJHOTJzYWtTTzFZNU9Id3Z0emZvNWtRRGFWdENaTmcxamRieWE3M0cy?=
 =?utf-8?B?eS9YZU9PWFQ1bTBabXZpWXd1OEExamxZUTVERVlhc1ZJRTZIUXJDNEVHNDBM?=
 =?utf-8?B?dm9wQ0RDeEh3N3dUbjlsSFlscmhGM3NpN0toU3F2U2FHTWNTb1l3TS81RG5S?=
 =?utf-8?B?RnpIMmVBMmQ3V1R5TU1RczF2aXovajBTa2dRelZFdXFxanlHeWJvcnpWU3BW?=
 =?utf-8?B?THFFQ1Q4dDFIOFp6UWVOdDQ1bzJ5QlVaUW9aU1dXeGNvUVdLNGFEVlpqYlAz?=
 =?utf-8?B?NEJaenFaajY4VDV5Y0tXVm9KWDJLL1BJdGY4VEI5d3F0aXFlVjR1UDV4djE2?=
 =?utf-8?B?VUZHUENDQnlSV2srS1ZaZDMvZ2Y0T2tweThKS2QzVE9JeVRzUEhDbVBnT2Z3?=
 =?utf-8?B?ZlhGTHpvWWhiN1R1dzNIaWRHelFCdlljeHZ6bTZack1Ib29yamZMUEFTWEFD?=
 =?utf-8?B?c1R4WTF0bnVxNG1sNktvRmljK2tWUDJjTFp4YytML2p6RHFaRFZqdWpWeUxl?=
 =?utf-8?B?ZEJzVUVMSmFmTExhbGM5RjJ5cmFpNWRueEliYnBxckRway9XamFFZVNBSEly?=
 =?utf-8?B?NTdCQ3BaZitDMmNPQW1UbDZtSGovWHRvcHBzRVFEbTQvNmJtOVNVRFY1WDd6?=
 =?utf-8?B?SmJISmRLSC95NVJrY0kxZU16R2tLOHpJVnVtV1RsL2JxV28xR1dpT1ZZdTB4?=
 =?utf-8?B?S1VXL1pZN2xOUzRnWHozY0RkMXE2S2djbDI2c25jVVRNUUtndFVucy9Xb21u?=
 =?utf-8?B?U0RURU5CRWNRTlovS2EyYzNIUUdvbFNzZ2RlZ2NGbE5oVjRPbk5sQm81dk85?=
 =?utf-8?B?dEVObHA4MEF4d0JXc3pTYkZiNmk4ZDdZam15RmNoSVVEWGw4TnRnaEQ2VCtV?=
 =?utf-8?B?ZkJkYkpxZ1lWSEVQK2djUjFiTDFBcUs1VWVqOGxLSjBRZGJKNnJkTXRDUnZn?=
 =?utf-8?B?WlBHYXB2dkdWQTNPZHo4a0g1NC9FdXNpcEJOTzZ1OTBWaUpnODZSS3pXcFB1?=
 =?utf-8?B?TEhaaVdQeWpMVmNHd3BxUGdCRWtuaEIzZ21uNWo5RmR3VUg2TmNqcjhqeGl1?=
 =?utf-8?B?WGlRcTFuTVgxaVFxeDB3QXAxUnMvclNCY3hYOHBjZmhzMzFOUEw1Y2g4N0M1?=
 =?utf-8?B?WkdycERxN3ZaVkdTditrVUcyVkpGU3ZwQkRGcFVSSnlWRnJCWGR4MzdCdDFw?=
 =?utf-8?B?cmZPa01wTUtDZ1pXZElNU2t4MmFGUGloeUdQdUpTWUtvNlFpTituSXpERWhV?=
 =?utf-8?B?VGc3ekk3U3NwS0ZQWFNqR0VEelJtR09nN01qU0JrKyt2OEZpVVl4VkJQVkNJ?=
 =?utf-8?B?ajl3L3Rkb1ZtZDE0dlFHZGp3SUdEcnF1ZFdZYzYyZ05rNWg5N05Ma2QybktZ?=
 =?utf-8?B?bThwVjdLMTVUYmR3dzZmcDNaRDhwcVhWQzNzV3BxWEYvYzBXMlB1NVhQN3V3?=
 =?utf-8?B?WWluTFBkaGZ0NXdLRk1lZVZLQWpJYnd3UDBRWkx2QVpLSGVGZ0F0SWd3REpp?=
 =?utf-8?B?U2ZSQzFVekJYaTRyMXdNTEc5bGR1RVpFRjFVMVRLYmtsVlZTcjQ0NUtuc3pU?=
 =?utf-8?B?SXVtU2VBWDJyRHVNRmJvNUFlTUUzN3ZWYVVkY1JUZnVESzdoaFpZVkdCTUdD?=
 =?utf-8?B?NFh1UTRINTZmaWhmN2RhT1RMb3l1WEtwdkhRK1lTb1dQUDVJZjZPblJmZ1l2?=
 =?utf-8?B?MC9HdHA5TWpIVnFaclNZTExpUlBuOGZ3U3VNY0tlRXZjenRUMzVGc3FvRjFT?=
 =?utf-8?B?Y2ptc0NsMjMrQWF1STFGQ2hTQ2NseTM5UVBaVE5HeVdPVzNvUVQ2by9QSU5E?=
 =?utf-8?B?L09BYWNEeWpPNFJaZUlCcmNxZmN2UGNiYmkrWHFPd3NyTU9JcmlSbDB2c0pC?=
 =?utf-8?B?cnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?K3R2c2Y4bVZiT1RRSW5PWlE2SXY0NmlGMmpGTWNGa2FSR0MxSTRxTWpZL0VK?=
 =?utf-8?B?dnk3OHFFSzliTkU1STBaZ0ZTMlpBcjl0MGs5L3Z3RjN5RmJVdG80QVJQb3Nt?=
 =?utf-8?B?YmZZR3kvcEhnN3U2YklSNUtLT2piQUNQY0JIZ083UzRVWnpRbTQ4OWdzZFlB?=
 =?utf-8?B?cEF0RWpObEtOTW5LS29pUGR6UTlvOVZUeTdMb2pIQ3BFQTgzZE91bnh6bW1p?=
 =?utf-8?B?czBwczU1alplTjV0dlo2QmpDcGYvTjR2SDBmS3VmQVYwR1ExTjlWU1IvZFVE?=
 =?utf-8?B?M21oWmJETWdFOFhoODByRGEyV1hCU0M2andyWGt2RWRqbThtWTErdVUvOVpS?=
 =?utf-8?B?TW9NN0x6Yi9hZnJNZmNRNWxpR3BSS2RlZ3ljbk40ZXI1bC9IRTFYYTNiRDlx?=
 =?utf-8?B?NlgzVGxzNEFpODVyUGpNRXZhQnhrSjl0THBCNmU5NDlOQ2QxNXlZemZXVmZu?=
 =?utf-8?B?UlZCcXQ0bXRMUzAzbFN1ZUtRSlZsTStEUUduQktSQU96a29sYXB5Skx3UFNo?=
 =?utf-8?B?Q2k3K2JLb3R3QVBFenkzVFB1djVOSzVmS1hLaVVXLytLRVdLc1VyOTJEcFhh?=
 =?utf-8?B?aUdKTms5MEl4QzJ5NzNGZnRENm15eWppTUswcGlhZVl4Z3RsSHE2N2ZnOWU3?=
 =?utf-8?B?NXF3ZTZ2ZzZ4aVQwTnZHQXB1SEFaRFY3ZnF4M2tnN09vZ0RpKytLUEY2Tld3?=
 =?utf-8?B?U3F2TkN2SlNaeDZtUnlydU5QeVpNNjYwcmZXTWppY1ZoV2RTNlRTb3FVa0xi?=
 =?utf-8?B?eHRJaWxIVi9YWkJrbDdWSHVFdjg3dE1pWW1VWmo0YWNLb1pqUzdZQ3pBNksv?=
 =?utf-8?B?NDFjeFU4WFovV1V6RXhvcGtJU0dEbHpzcU5Ka0hKbTQ2dVdtMVlCT0dMQmVW?=
 =?utf-8?B?NWVDUVRCM0FRaUZlSWVmY3RuaE1STXF1QTd4cm4xWEdleFhnUTluZzdlK1BR?=
 =?utf-8?B?MWE0L3ZOMHZNOXZITm5BSFY3cnE3dkdVQ2VTeDNKeHlJU1EvNGVjaHVzV29q?=
 =?utf-8?B?K1hETW9NUXF2K3hmOG9WQWdMb0ZRODJtMFlrVy83bENLMjVtU2Y4RG9UZi92?=
 =?utf-8?B?QmFIeWpsbHhXZUhoV3FmTk5nT1hwbmZ2SURZQjArZ09TcS9rV0o4SXVsb1Q4?=
 =?utf-8?B?NFdoWlhudzZkTFE4RFhrOG56NlgvUjdsaWkxQXB4dnl1Q2FzeTZQbEVmNEpV?=
 =?utf-8?B?OXZwMVVjVUNDd3F5VTBwWjFHQXM5NTlzZi9OVE9vb3M3ZUFrZVdFT2ptVEdW?=
 =?utf-8?B?NjJKUnRKQ2hUMHRFREE2Z3VONGRnUWJYRmlGOUQya2Iwdy9OYkRDUmVseUgy?=
 =?utf-8?B?MHRNR0RLYVhHbEF0ZXkvRUZ3bFo3T2pKQjZwdlhNUi95U1AyQTNKemNLZDM2?=
 =?utf-8?B?bGJkU3dXQXBVd2ZXWFlLaTV6YklaYkdSSTMwbUV5RVdmajRGQUx3MDlYY0cw?=
 =?utf-8?B?UTJQUDl1QU5GcmxrbkZTWmVkaCtXSHArSUkwWG1JOVFJYU8veW13UnZEVjg3?=
 =?utf-8?B?V2tvVW1PcWhWQnFoQjdZdHJNRGR2R0xTeEVNVlI2YWJwTDM1NVc2Z083SEYy?=
 =?utf-8?B?L3JOTmUycEl3OTB3TUd5ckwzMXNSSVFVZkU1NEhLL0pVVVpVN2FiSGV2Znh3?=
 =?utf-8?B?cEIyMHpjTWxzYlJxVldOUU5uWVlrOGpJSkZKVDd1MVZSVGxSN2x2Rzd0aHBD?=
 =?utf-8?B?RFBJR1Y5U3pBUHMzZ0NyNFBZdGIwRjhRTnJsMEtZVzlkbXpNZVh0MHdnTERC?=
 =?utf-8?B?TEI3akIvQnVaK1BMNUYvaHVvRDVYamVLYUJyak45SFF3T1p2bjBYVHBaaFUv?=
 =?utf-8?B?NnZtQnFGei9iRHBkeWVaQktPWVVDM2dhcFdsQktMZE1NQzNhLzViS0oyZUJz?=
 =?utf-8?B?UUl2bStrd0ErdnhVYXg1U1FXZjlvRDJqVzJwWWtMK0xWVHRPMElhcFJlWDV6?=
 =?utf-8?Q?061tmD9SuzY=3D?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 767b487c-ad9f-4bdb-44b6-08db36f3c25b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 23:07:57.2944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b+/bC7rl4pbbyQiALCdhosJKIP5eAgzCn6shFLn0/u4cz2MsIziGr4KMiKfqYAriJxI+UwuI+yKZB+XPIllIvcY9mr4+/MUjnZHNrc+tcrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB5952
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/04/2023 10:58 pm, Peter Zijlstra wrote:
> On Mon, Apr 03, 2023 at 10:06:01PM +0800, Lai Jiangshan wrote:
>> +/* Replicate the interrupted atomic-IST-entry's CLEAR_REGS macro. */
>> +static __always_inline void replicate_clear_regs(struct pt_regs *target)
>> +{
>> +	target->di  = 0;
>> +	target->si  = 0;
>> +	target->dx  = 0;
>> +	target->cx  = 0;
>> +	target->ax  = 0;
>> +	target->r8  = 0;
>> +	target->r9  = 0;
>> +	target->r10 = 0;
>> +	target->r11 = 0;
>> +	target->bx  = 0;
>> +	target->bp  = 0;
>> +	target->r12 = 0;
>> +	target->r13 = 0;
>> +	target->r14 = 0;
>> +	target->r15 = 0;
>> +}
> I think there's compilers smart enough to see through your attempts at
> avoiding mem{set,cpy}() there

Indeed.  It took a little bit of convincing (needed 4 extra registers to
zero), but https://godbolt.org/z/7rvb8db66

Including Peter's other observation about speculation safety, you
basically can't have any C at all before passing IBRS/UNRET/whatever
else comes along in the future.

Otherwise, the compiler will make you wish you'd written it in asm the
first time around.

~Andrew
