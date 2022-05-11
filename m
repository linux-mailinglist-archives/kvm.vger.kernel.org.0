Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B247252376E
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 17:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343808AbiEKPhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 11:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343789AbiEKPhp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 11:37:45 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739EA6FD29;
        Wed, 11 May 2022 08:37:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8TVTE9wfOYr/QgxBeVXAePa8Chet8iC+qgD6AfMUk6Atgg66as1iVdgtd+QvdmCezDsgBsmOFHQ4ipipuihAWwdN/1pm2g+5NIuhQgXdPA3uMrp2hiBZ0368Y0iysaDbqsYMxec0PiS1w2plths/4I/0+EQ5bju8JwtXAEUIP9uKLPzjaWtSbwzqTqdB+Z7UCtLPYEgy1wDA4PlsKVQD7rbkm6NRzR3JGBwpC07UTk/QT50Aox9l8wb/P9Qj4sCrUBD2aKJ0H3YfX8wQshDSgjz4q8cCD71u4pQVMc4eUTAlXJvODz4KOBXep7FL6Fv3KTlWoSKlVexAe59izQ4zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QnOw+tB3IgQFKLiFZ7/Hvy/9UP8tmKyw496+KXIyNKk=;
 b=fqD4fbtW2fuZZrIShVCRdmcQoW1FOVgk6JFowEYUuUS+eNTBOic59Qr/GPZsMyYmUaimx42sKD/l8/jHP7USISZuTIcnOpnJI5yFeY15G0RZr57WlrYj2qpnRVEHlAYgwn61Cj+OkacQLvBBAvU+jYGAkm2joFdpn5rK3RoN1r7y1jgCzf8GOn2zB3zvEVU3YwT2ZzqTsZEkHgbBjC3a2Mno5lI1CnqyfhXmvUFql0dyfrPZo4NaFlyddsjUrHWcjQNDKAQA38Z4ihq36+770xQV+2i6bufvKXE8470QqEt6eqW3pzl+znNivSgO2TAXL9lJl1FimVBktSXTejPG/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnOw+tB3IgQFKLiFZ7/Hvy/9UP8tmKyw496+KXIyNKk=;
 b=fJ12g+2YcaEQ2NE0TOmMZx8GhuC5B6RDyhOucGvmihg0KuaRdQg5DVaZr2LZVUzYhAO/ZYizAxxhqXUFpd2BBhgcoU+1vT1x41roHSeeCiez3rYJZuL1y9Htv9cH1yACAjWVjudNgOrg9jjoUxal/Gfe55baLmwT7iwJxCB4230=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM6PR12MB4187.namprd12.prod.outlook.com (2603:10b6:5:212::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.21; Wed, 11 May 2022 15:37:42 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b%4]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 15:37:41 +0000
Message-ID: <3fa12834-d144-54d8-0bf8-8a72e726db99@amd.com>
Date:   Wed, 11 May 2022 22:37:31 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v4 10/15] KVM: SVM: Introduce helper functions to
 (de)activate AVIC and x2AVIC
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com,
        kernel test robot <lkp@intel.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
 <20220508023930.12881-11-suravee.suthikulpanit@amd.com>
 <a60d885cf4b0b11aca730273ff317546362bff83.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <a60d885cf4b0b11aca730273ff317546362bff83.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK0PR03CA0110.apcprd03.prod.outlook.com
 (2603:1096:203:b0::26) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 425f6ecf-3dd0-498e-fc4f-08da33642fc7
X-MS-TrafficTypeDiagnostic: DM6PR12MB4187:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB41875B8F454E9E43E9D4E233F3C89@DM6PR12MB4187.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BzogHVp8reIftco/CvlO9tCe6D8BfreVVnTelbkM3n0KyydSZVWY+juNqet0dfxVCcrBn+Vadfmi1tleMO9pHNoqoInf/JAx0PIQNu7ZT35oQmDeJkk5/zy1P/J3Q++NQhHevrY+GS9n50XmPtGxoftJRDS+a3jJD8YjaplTgwNT9PC/JMEgS3asue3u3Y6bsMPonLzneFdMl7rmlUzv4oys09G893pnEFNutrw5ENIYs4Jvz9GkOe4J/X+o0QvYkfGQbHEUyQQ4oSOZtNPVxqytSyn5xuUnJT7xJeyD+WgUV7HrnRwjYbgXHnYsvOSwDaHLzTUNsEUgl0T5pInUJsPxlkjwyDS2JB78fJZgcUIzsF+/aGbxopaQ6wwGuB0LCVabO+snY1EWy0si8DMMmEOxcBq2UCqgNe9HvoXYChYu2q7XD9/FcJHJuPyVQCne8NS8LLxk6exdzfpLOHNmqXHrcH6m91DKhGkj6aU/DAKyq01FjLgFuk/J7RcSKBjKJSA9D+IxcAKcW3FuUTeiN35CeDCRD1Ks0Dm+gx3jAeEcq/G0yAyYg5ABsD5Uavvsf2R1aENuloOI0kNYyADG+oPdr7IGhQYFpdeBGWoIMl5FUSOBiZ2YLhVp/BNPJW99kviAbPAFRrII5ePX9UZUhaNheNgKggcITgPwG2CiWY9Ups3wymlNDdoSYdlZbldVfWOeRRn5zpNvtxuCQKCEbhRtehwpVVSROsipFO25QVQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(38100700002)(6512007)(26005)(4326008)(8676002)(36756003)(31686004)(186003)(66556008)(316002)(66946007)(66476007)(2906002)(53546011)(508600001)(6506007)(31696002)(86362001)(6666004)(6486002)(8936002)(83380400001)(44832011)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0dtS1VydHkvZWl4U0M3bGliK010NXR2U3lBZFJDaXJ0d0gxZlhjTHRaNFRZ?=
 =?utf-8?B?cCs2K3ZFUStuaXpjaE91QzYzVGI5T2JjZGJxcWVGczdESXVSKysycVgzZllY?=
 =?utf-8?B?OVdTYXNMRDl3ZTFYc2NXcUV5azl1VzdPMVBlaEpNRUZWM0ZDYU1TU0ZoQzVP?=
 =?utf-8?B?MDZ6eTVqN0FOZ04wcWE2M1htRzhDaGhDbXNXTmJydXBrRTJIdjZNSVhKTU0z?=
 =?utf-8?B?SC9oSVlBdVZCa0ZTWFFCYzNrYWhnOUFrTC9wcUg1Q2pMdUc5b25kWFhnYkhs?=
 =?utf-8?B?UWE3WFJ5ZE0rSi9nMG5Nc28xVEV0TTZiWkFISWJTTTFpeWcycnJrVGJ0QTdG?=
 =?utf-8?B?NE9JZGRpcVVUUGZFV2hLYU96NXJPRWtQaEY5N1l3VUt3VnUxbnlVZ1pOMXIv?=
 =?utf-8?B?dkJ4VWVGZzV6V0dKSnNoVnlSRytzOTlSVHFFQXFBbzNBWlBvT0czOTMvQUZv?=
 =?utf-8?B?Q0lSUHV6WWNkaEpmMEJKSG40dUxtMzBWTUZGNmJ5a0t3ZHBRRC80VTErdkt3?=
 =?utf-8?B?UGZCZ2ZDTkkwV1NNZWNSVVByRGZIV1BDVU01bWhnNGE3ZTNWSlpQYWhYbXB3?=
 =?utf-8?B?RGZtbFBQWEJQeXZZVWFDeVJ5aTRvTUZMeDZzOC9vYmw2aW9KbkRrbEF4THlh?=
 =?utf-8?B?U2I0M3VzMjBaN0kva0g3NlZDaGFyK0MzOVRXVnZxalU4UG44bU9qUVhsWndp?=
 =?utf-8?B?Q3R2a0M4cDE3REtwa2tUSy9tQ2gxMUQ2TzBBeEZ3RG9tTkZkMWV1MVJJQlhp?=
 =?utf-8?B?c21QWHFiQWxObytOUkd2S2N5c2Y3WDRJbmNVRjZFdzV4Q0hiczdWWnhTQ2x0?=
 =?utf-8?B?MklhWWRvOFRSM2N6K1JyMlIrUVJLQmdrWVpiQTd5czZtOS9XUUVsclp1N0s0?=
 =?utf-8?B?VDRYc1lTRmxwZlY1NWt2LzVUU2RTMFd6RUorMDllYlA2K3JmQUp5UkVtSzN0?=
 =?utf-8?B?bnVqK25EVWJDL2ZEbHRQc2VJSzBLTFlLSXFqMmhJa3UwN0QxMzZjZzdJdE9v?=
 =?utf-8?B?VEtLVk41R1h2dHl1dU5CazhLVE9QeDlXQXhHL3R3SVdXeGVndmtuOUJFZ0tu?=
 =?utf-8?B?NFBuZGk2ZDVsUXlSVHlEamN5MEh2bjBpRHF5VWpMSmExTlMrWUNROFlWM1Fk?=
 =?utf-8?B?NVpnNllOUWpkbGFBcmdwUGU3c0lkWllCemZTUDdkUUxvdzAyNi83clFhSmlN?=
 =?utf-8?B?azZFTDMxckNsYkpkRUkvYTZBdk04UjBVb2hRWVROMUhHQjVWTXJGbWdWcHJw?=
 =?utf-8?B?cHZBeXl0OW9kWnZxN0x4WUdhSnRjcmgyNVJDZGoxS09jS0dWb01FRnpQMk1P?=
 =?utf-8?B?SDk3aGlBMXVWbGZrdy9RWWtYZ0VkaHpzVUJlcWZiTCtTcWhqSzFwSy9BOVl2?=
 =?utf-8?B?RUtkNmtBQmtZc1BaTEZvZVd1OC9XUk9nQ05xTkpjM3NDb3laNTJ6Ym5ibjJ5?=
 =?utf-8?B?SlRoQ3hKUGppcEticGM1UHhxNEVlNFU1SmZuMngxNXJISU0ySFNwWkg0Q3pK?=
 =?utf-8?B?S3M5QUQ3SWs5MEpXS3d3OS9QMGxsdVZNRU1pUmlEU0Y3aHNJOXdiRzhjblVk?=
 =?utf-8?B?cEhyZkFYdlpTSWdUU3lyNStvZHpzYlYwSGpVNVJnRnQ3dTNTaU9KQnpnTENu?=
 =?utf-8?B?OTcwUmFrdEM0SEd0NitaZFExT0lhY3lSd1h1eEdVOC8wOXNZL0FBb2JUMis4?=
 =?utf-8?B?QThjSFdFaDFKdU1YRURySmJ0bUxJcGxhcXFTS2NubGM2SVlHRjVZN0piaks1?=
 =?utf-8?B?K2F2YXhoTzg5bnNmejU1SEJKdVo1NmlXbTA5S2Uxa3ZtcGsrWFNVMHNhM1lO?=
 =?utf-8?B?cHdtamd5M3Z5VGlIbGQ5cjAvOUlKeFF4ejhDdnZEV0lNS3h1VXYrZGdnM2R6?=
 =?utf-8?B?YTE4ZGdzSlVkdXRCeXBOaTJQUmR4ODc4d0ozSytBRTlUYVZkK0piMFhxcW9D?=
 =?utf-8?B?cWROamJXcWF3cXR2WEMxcUJDOFRrRjNYVVFEM2p1YlE2dE5aVDJrU3gyUU1l?=
 =?utf-8?B?dUZMY2pINllVT2sweGwxcnUxUUdxbzh4TG1hQzUydVVGcm1FOC9mSmxSaWFp?=
 =?utf-8?B?RXUrVUpROXpkY2UwRDROcFN0Z0hublpqQVB4TE9ORDMwOTlCcFVLZmxja3Fq?=
 =?utf-8?B?L0RwOXRENnliYVlBZFNJcEZIR3hYbUt1bDY0ODhvUDdGemovMldoS0Jnb0hz?=
 =?utf-8?B?Y2pMRmxSL0hkUjA4UVk5Umh5TnBPTGdYdU9QUzNhbmdENi85bit1bE1tano1?=
 =?utf-8?B?WjRZcE9SMlFRYUo0YVFHZWM4MnVlTEluQ0U2UTdUY25uMitYQXZhb0hqUnJz?=
 =?utf-8?B?MVpBRVRiR0dveGkyR2M1WmNIZGRKM2dTQUN3MG9QRnA2RTQrYXE4Zz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 425f6ecf-3dd0-498e-fc4f-08da33642fc7
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 15:37:41.9134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7WyPFmKOi5Dp/q6UWOH0iQswiALk6SYgk/EY1uQffPRtiGvX1psvS0UU7qp1G/gW6yABnRdeogXXV1oxiaR2jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4187
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim,

On 5/9/22 8:42 PM, Maxim Levitsky wrote:
>...
> 
> So I did some testing, and reviewed this code again with regard to nesting,
> and now I see that it has CVE worthy bug, so have to revoke my Reviewed-By.
> 
> This is what happens:
> 
> On nested VM entry, *request to inhibit AVIC is done*, and then nested msr bitmap
> is calculated, still with all X2AVIC msrs open,
> 
> 1. nested_svm_vmrun -> enter_svm_guest_mode -> kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
> 2. nested_svm_vmrun -> nested_svm_vmrun_msrpm
> 
> But the nested guest will be entered without AVIC active
> (since we don't yet support nested avic and it is optional anyway), thus if the nested guest
> also doesn't intercept those msrs, it will gain access to the *host* x2apic msrs. Ooops.

Shouldn't this be changed to intercept the x2APIC msrs because of the following logic?

kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu)
     kvm_vcpu_update_apicv(vcpu)
         static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu)
             avic_deactivate_vmcb()
                 svm_set_x2apic_msr_interception(true)

> I think the easist way to fix this for now, is to make nested_svm_vmrun_msrpm
> never open access to x2apic msrs regardless of the host bitmap value, but in the long
> term the whole thing needs to be refactored.

Agree.

> Another thing I noted is that avic_deactivate_vmcb should not touch avic msrs
> when avic_mode == AVIC_MODE_X1, it is just a waste of time.

We can add the check.

> Also updating these msr intercepts is pointless if the guest doesn't use x2apic.

We can also add the check.

Best Regards,
Suravee
