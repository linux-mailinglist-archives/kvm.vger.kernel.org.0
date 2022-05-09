Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F349F51FB41
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 13:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbiEIL1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 07:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbiEIL1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 07:27:34 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06A31C9ADD;
        Mon,  9 May 2022 04:23:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIfTsHLfTuQbNcVw6L7eMYB/GL2H3IqOGF1w6Iu4HATNlxzxeVNrliEhmu8cHX7OisHE5vR8w1oKN0TTN14WZ4MqZJHAv1ldkYTSwsRtMPRInIhb4o5cWOUQwxhKvHVc4RUeK0wgQQyD8Rul7dnW28YiBxipqc30gq5Y8NvhIEld2SnVxHKFndPdKy2Fe+FJILkMrtN6VR/9dFCcz4RehE1gUoP1fleMzN2yVBVRmaeLxyG/cvI0uIi9a1ibKB5p7isRPobK5FpEJd6qjZKXqAdoSBytr2z6nrxLeTiKuUuHX28To3g0poUgbcNdOtZvsiDFwCJoeEWsfzrgM3hFpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wi4E6kxwg9ySxgHbGXu88iFBWeV/Jw31UpZe45PtEk4=;
 b=CmBeld0eGbSqkUAv/bin/71p/DoQZayQ67eTXyeEJ6AyI8t/Od3vwe1EPmuiG0g6KsgoLgtQIIO/ciGq2pxJisir0tOmU4HxleeACem6TxsCiJ+VNPqzIZHJC58kGvEU3Eb0fzw0Nch+msHrX+OZ4OFcGu16z7kqgX2YLZHcP6KCMyoJDj/Si26ibicLGwePQ6825pevwYzyuJ+9YA9zZpwulwlZ6EBCMg+dRDGjNHqakObUABVdMV1Rr6PxNHYTB751Dm/4zjEG5nfDxQzyMvmr1w7RLYzhITmQv4cVuc0CbRSqRn94T2lqw1579MeQVuIcBE917hSu9/INIgSmcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wi4E6kxwg9ySxgHbGXu88iFBWeV/Jw31UpZe45PtEk4=;
 b=G0gNZ1hYkMseJ68+z2gCo94JQST1h+Zb4NkwYmBZB/sSQ4ne7zFTNAOjwURvfcu2JQbAdzPrlEUG9S6ovQweccrUY8jOK0oufvjuUSyFUkL9eIWaHc5djb+80RxnAgfAR/uGZVRIPIRnQPL6Z9qtCapOyvglrBA6lBqBdsiO7zQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 BYAPR12MB4629.namprd12.prod.outlook.com (2603:10b6:a03:111::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Mon, 9 May
 2022 11:23:29 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b%4]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 11:23:28 +0000
Message-ID: <b3047d27-9681-6b9b-f747-c5428a250b02@amd.com>
Date:   Mon, 9 May 2022 18:23:17 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4 12/15] KVM: SVM: Introduce hybrid-AVIC mode
Content-Language: en-US
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, jon.grimm@amd.com, wei.huang2@amd.com,
        terry.bowman@amd.com, Maxim Levitsky <mlevisk@redhat.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
 <20220508023930.12881-13-suravee.suthikulpanit@amd.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20220508023930.12881-13-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:49::10) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85b56901-562b-4276-7faf-08da31ae5749
X-MS-TrafficTypeDiagnostic: BYAPR12MB4629:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB46292242BF6E32F4E29B36D6F3C69@BYAPR12MB4629.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xy8B0Q6tvLJbDVhuqEtpMGVXFL8PX0XHcFG/7Nm2bw8aF073r/dZCJz0t9U+2zhKr7n7+58iJX7DBHqMBj8WM/MYB2Wt4w5s87ypxuL0ppzggcK/3IW1fQXd/o0ii2sf76xi6bQWDF1bo6V/qe8yIxIMOaHT1ulSFNFGiaXTMJtfcvnYUkN31tRIogQaJ6m3LtUdcU8g/G9otVHk/Q4JppstYquIEsipWsomLBhbuW6Yy45Cyjndv/o44pgEOr7F1oZkhha1rTpKh9u/sjSnvcEOMMxMcXARRFpSYIZXfwV73QgrnhuJsf+ZbF0RRi9na5kyGb94BFNfqfoYck4Lya+mB9zsr58Mv5YmeuUaxXwduR4KYdyn8A1qmTCg9U8YqGfvXKgLEwsojJHHMt1iq6IQqdFG2PEZ/ogZFGPvvDXooec3mZgGVaXqmaPOTVB9VZgkBpVcMSOxQP+5QH633QJGERk0CE+7HO70Pzupg3FukHAKFSlIxb2cx+OYO6c4VV0XryLrRbiBaZAIAFfwsJDgUP2r/C2JJd8EqKqnKWXYTWfA5eOrnbuVGQcMSAoicDs+THbFUHD6sAlyyG/G/E3PXRidVsmuVqAYgavxYE6gwf2NJYvcVZgrIIsL1ZJeT8JBfv2WQQknBCKk7f8COeDt6bbA/4g9WU1IqTo4LdLMTR9YmJ01PYGgmEG8KPnYcgxHiuKOk1FFYtXKBd0uPKJnCa/Rc0uXIbwWydKrxzNmQkIOybKDebIK/UV3hcxI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(2906002)(66476007)(66946007)(8676002)(31696002)(508600001)(6486002)(86362001)(38100700002)(316002)(83380400001)(8936002)(2616005)(5660300002)(4326008)(6512007)(4744005)(36756003)(26005)(186003)(31686004)(53546011)(6666004)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cG9Fbi9OMmorajRpLy9yZlVxZjVLRHo4UTVvTThtZkE4QXVnK3dYcTBUcDZN?=
 =?utf-8?B?aW9LdGluQjR0NFZnb09sQjBhaUlWdTdKWjQwck9RaUcxRnk5cWhEeTdkcHI1?=
 =?utf-8?B?M2JhTytJMVFXZ2xFSGpDRGVpbVNyWm1uQzkxR04zSkN6ZHNEcktaMFdCVHd1?=
 =?utf-8?B?MTBmQUJybmZSUFk2VkNUMTNrc3M2OWFlaS9nTTBKS1FoSmo5RTFobXh5aDB2?=
 =?utf-8?B?b3JUNkF3Wlh5akJxVVNadUxQcjZ3QnFqTXlQY2NVNCtYNzNQd0oxVG1TTk5j?=
 =?utf-8?B?L3MxejlDRkZLYTJpdXR6OHh3MTdrUExBREtxamJPU0VSZUt5YTQ2MVc4UWUx?=
 =?utf-8?B?dGdWZmdsakhSQzE1VGo3MGg2Q3k3WVMxVXc4Mjh4NE1MQVdEYkEvMmtLRVEw?=
 =?utf-8?B?dDk3Rm9VZ1U3K2d5WXVTMWxDeERmdlozVXU5U1R6L3JOazJCRzlBVDFYbWMr?=
 =?utf-8?B?MFo1cytSWDlFcjdxV2ZEcHE1V3p4d0dGN1JpUWtkZDYvaWhuUFFqakVoWlUy?=
 =?utf-8?B?RlUrYWNVZnBNYlBQT1pMMnNyUmlTSEYyTkRMNzlGdUdoMGk4NFExWFpxNnVu?=
 =?utf-8?B?S1JUQmhSUllZeU5LNW1RSDQ4V1VVWUFYNTdaS1J1NTFuTWhxN1VyZmlydS9W?=
 =?utf-8?B?SWVWbCtVOVVlOS9Gc3JDbFhSSmhTVkc3T3FmZGo4cy9IUFNyNGdkUGJOVTVP?=
 =?utf-8?B?anlqQlZEKzY3NkdZbllQNnFMQ2V3dGx5NEZzVGZ3emNjWmdWbXA2YmtWV29a?=
 =?utf-8?B?bVYvam5pZXIwN0NNTFJPakZ1Y2pTNnFoeXBwWGtOVHFhbTlrd3k3cE5KUUdV?=
 =?utf-8?B?bGtQdlRWNWRvV2VmV1FQRmY0MHNYaEt4ZGZjb2ZpRzFNSmxGdHEvL05nUHVo?=
 =?utf-8?B?MVhWQUhZb1lnVzJqMDg3aXpmRmp4ekRrTithcXcyOWFWUHpVUmVSNU9HT1o4?=
 =?utf-8?B?czdKNGFIdEZvY1J5Y3AzMmlKOVdHR0Rxdng3UjZnZzhTN1FVMVdOOEQyendl?=
 =?utf-8?B?R2I2N2dLL0VjbCttRkFXSEhxV3pHQ0pGL2hFQlpVSW14bmNWQS9ZSUhNYktB?=
 =?utf-8?B?TlNkcFBKNDNpL21qRmViVFV4Z29hMlFVczkxaDlESVpZMmUxeDlsenRRc3FQ?=
 =?utf-8?B?L0dSQ3BRcVlEZ0R5bHk5Yi9NSjZWeGtKTXI5RmdqdTdFNEV0OHhtT0puRHRt?=
 =?utf-8?B?NFRHb1o5YTUya0lCSnNpR2xjNDdRU0JFcldRdFNUU0tLTzNETUp2cGlnY2lU?=
 =?utf-8?B?MmNSSFgxY052RlJIcXQxMjVkOGJFRGpwNnY4czlxQUh2amR1Z0VBbzNMNUd0?=
 =?utf-8?B?T2tJNitnY0VrUDBrSjh6TDZwWFIrSXRIOXlsMTJLSW9kSStHQ0FlR3crMFRH?=
 =?utf-8?B?SWtBUW9JR1ZDZUxLVWFhS3YwR29GM1d2ZWhCeTdPWGVaWHVyRm42NS9rNlNy?=
 =?utf-8?B?ZnR2TXZyclBxSitTSWRMN2FUbWtYSzJaeDhneWpzZzJWdmZtZEVuYjZONnVn?=
 =?utf-8?B?d3ZVWUFtRW56U2RWemxpR3RyNDRVRzQvUnRhQWZTZ1BWUHllc2Z6RWRzVGpl?=
 =?utf-8?B?dmVueTkvS01IN0pRNU9UOXFiaHNPckF1djhCbi9JeVRURjVrc0lOcWRGeHJQ?=
 =?utf-8?B?NkNIcEZSb2FYWDZZbGpqUnZqbDFLNDRoMW92TFA5Z1hURVdzaVdpR3RNZ3JH?=
 =?utf-8?B?ZGZYU1RVZTB0QXk5cFZQbkM0eEhRT0ZPazhYRDFZalVDdEZnN2E5Y2lyZG5h?=
 =?utf-8?B?cVRFMElvdDRqVXE3WCtMcXMwTFlnY0NiVi8yN2VZWGtDejV2dnF0SS95VE5m?=
 =?utf-8?B?TGNMZzJ6MUEyZFAyQldCdldCNDBGTkJoaTdTL3JmOUhKWVRBMHRNVmJYVzlB?=
 =?utf-8?B?UWdaYjhyWE9zSE5GSUNERjR0Ym5XMVFiTVBieHdOc1dKYjF1NWcrd2NGUnBz?=
 =?utf-8?B?b2ZiM1Z0aFZ4dmZoQ3pJSmJzTlJMRlArRVBhQnF3d3dRbFh6SDFvb3o1MkJP?=
 =?utf-8?B?aEQ0Qnk0S1h0QXQ4cEtSQ04yMXhWR0txUXpJdklhOEZmaWdzUnUvZ2ZZZUdI?=
 =?utf-8?B?Z0UvbEQ0d1Z1SU1LSDExWmVkQjZxRXRseGNzUk5mNFVJY0tDbjRQSVpoTWdE?=
 =?utf-8?B?aVJhQjJFWjl3cnpjMXRzUFQ0c0VJYUg3eXBaZ2RXUTFablR0dEl5TjhubFpv?=
 =?utf-8?B?a2NnU21hdm1YSkdDOVRrWTRmUXpZWU9JRlJVRTh6cjhjRFJiTHNZSWlYRk5Y?=
 =?utf-8?B?WjVSNE9JRjAxUEd4b1dnYVpvakpkZlVHWWdjLy9GOE1KUUQxSElPWlpBMmVC?=
 =?utf-8?B?Nk0wdnA0QXlnMHJDNmk5dmtVSlA5dGlwUWU5QUtFM0xiRmZnZkI0Zz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b56901-562b-4276-7faf-08da31ae5749
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 11:23:28.9209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xcQuwflQlmVzNjjoD7c9PRVHVfwHNagEhmH6u5ApCGgXjYrhGZniwA9gTGHKaBrHdw0zm8sLBDaWTbtGeayrWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4629
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim / Paolo,

On 5/8/2022 9:39 AM, Suravee Suthikulpanit wrote:
> Currently, AVIC is inhibited when booting a VM w/ x2APIC support.
> because AVIC cannot virtualize x2APIC MSR register accesses.
> However, the AVIC doorbell can be used to accelerate interrupt
> injection into a running vCPU, while all guest accesses to x2APIC MSRs
> will be intercepted and emulated by KVM.
> 
> With hybrid-AVIC support, the APICV_INHIBIT_REASON_X2APIC is
> no longer enforced.
> 
> Suggested-by: Maxim Levitsky<mlevitsk@redhat.com>
> Reviewed-by: Maxim Levitsky<mlevisk@redhat.com>

Sorry for a typo here in the email of the "Reviewed-by" line.

Suravee
