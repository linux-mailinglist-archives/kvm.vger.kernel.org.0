Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2EF36E0EB
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 23:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhD1V3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 17:29:51 -0400
Received: from mail-dm6nam11on2068.outbound.protection.outlook.com ([40.107.223.68]:43680
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229593AbhD1V3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 17:29:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gb8iVXHvQ713jtIvgf392fD90h/gzXglwkVi9zI07yWME8mb/E3045Ad62i/bE39i/sLl22aPoNhIB7ZHY6xwIhh7Pp6WMEw2br1d/HvqPu5oDMs88+SV2k+Ia/UOr9kfktNVH/T67nYvJoChk0ncKkEE8SKXFnHJ2U7edVwwsTX0dNKvR1J/SjHCy9q2d8Yjus1phdu7czu0XoCGcPMrRPZD5fc1WkzSmG/i+pTst6CEMHTGdS/P2R0C/h/X8eikD2XjffedLZo6BDzhEtmRYxy5JHagari77ZxBAd6/DFBZT4lJi9S9rg5nH/RjOlEMRm6OALIxnyrsK+tXhuzWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7tq4EsWjuf1lch4ZBYoXtGOdABH7AuIiL6xazS/V8U=;
 b=fAIR/dPf0cQzbMIdk2qBO+NzLzIWM+6iR5ujLGbciNdhoGM1O8fHrbLFzwsMoO2FD/6G2cEh2UqoG0TlhbcUUPkZttrcNkA/ogCqY/UF9+G82kHWneQIHInYEEymQlMKcVBVUMdwDpTOt7IQ38Dd8qyhgGaX7GKpuCt5u+iKHbdBA7IQT3BW6FwAqP/TEIcWDdGJ0Jr91v2bGm5Wd7fMXrMkXdVe8I7rhY26+V/8i6EoIJ6K/vfyl29ItxKLz4pk8H7jIhJvN0Yg/P/oagDFDc8b5pazHeIDrpK0BVThckgZUk+ehAsvV+VyqN6i+iUoxeNPmZg3i25254IHCY1zsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7tq4EsWjuf1lch4ZBYoXtGOdABH7AuIiL6xazS/V8U=;
 b=my8f6JJcgAgpV8LVF+nh5o8Q1Tv+0LkdXyTIF9a2UqHXnATL2dll2r9F6R5y7s1a+48/Y4LtR+daBsvODrHXN9WpLNBblAspF0WUUCET7wOqDEwSuSaX5WoZDacYcjuArzlZveic+M+lf3ABUC4CFGVf+j/FW6gvv8MqPDnMdSk=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Wed, 28 Apr
 2021 21:29:04 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 21:29:04 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org, tglx@linutronix.de,
        jroedel@suse.de, thomas.lendacky@amd.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH 1/3] x86/sev-es: Rename sev-es.{ch} to sev.{ch}
To:     Borislav Petkov <bp@alien8.de>
References: <20210427111636.1207-1-brijesh.singh@amd.com>
 <20210427111636.1207-2-brijesh.singh@amd.com> <YIhCwtMA6WnDNvxt@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <da102340-eaee-c76b-9773-bc63cf0e8f11@amd.com>
Date:   Wed, 28 Apr 2021 16:29:01 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YIhCwtMA6WnDNvxt@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA0PR12CA0005.namprd12.prod.outlook.com
 (2603:10b6:806:6f::10) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR12CA0005.namprd12.prod.outlook.com (2603:10b6:806:6f::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Wed, 28 Apr 2021 21:29:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe054cbe-d563-40df-f9d0-08d90a8ca5ab
X-MS-TrafficTypeDiagnostic: SA0PR12MB4349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4349ECD0000740F3EE3292E2E5409@SA0PR12MB4349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: goX9FusoRUaxcRqd3Uu/vxLi34UAtaIPSXDx23EIsqk+7XWCNVaS5SKxYIjpYZAu0bi2QViavIN3PH0uczrTacazTorsaWqkulXke09sJv97zC1VfIUFXZ9Bo221l74mMQqjgwrZ/sTjx4QjuDrRdiCa3sR+Qo606WCkxUlotttHtWsMT5uUHRqFRjUMQZE9wdZ14uNlXXxmIeil+3sUu0xtZky6c0cXn8uCr5mP/vmMaqn2q5zn7kRuQue1afTNKj9EZLaPWW+Xp/lzJOFFWKzvrvW2iSi5L7lckD2ydzRYHQBx27abM/wwzEtEDHG0NaEwzuAtMNB08cVU7UTBcddsFQE6KureBQeXHX+/lE5Gy2pdX54k9zvWksYBMM44jl41ZeMuiyRFPg1YAibvtKoO7xefl00SjkR8gggGZpiVmifsNMrCFvK+qrCsGnn+vsDBB7wFlAtg6l6T5FM15zoe0iE44gdwORqY4r4pECfRz8r/cQEKEVj8soo/rTDYmaUBQG07tE4zB+orKfZP1SqyWDmI3FqeAmzwaiuudb9mK0W2uWgDIucRiRIikwZqr4nDVJzMkRjPNhqx89acuf9REZNF/Xc/Ia/Rv77bk3gSjRGFnvzPmC8WZV4aNnuDC/TGRhfmamtIV7bbs/AsR/ATfGEGy6W9ge6ejqloGxOhu9pcnPYWfPAU7Zmyy8LF7j6VmfjeoGV6NLSS28NrH5AI7qFOxGvxoR3EebospUQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39850400004)(366004)(44832011)(6512007)(6486002)(5660300002)(38350700002)(478600001)(83380400001)(6916009)(186003)(6506007)(66476007)(956004)(52116002)(8676002)(66556008)(36756003)(2906002)(66946007)(16526019)(31686004)(31696002)(38100700002)(2616005)(26005)(4326008)(86362001)(4744005)(316002)(53546011)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y0pVWFdNVXBlTkcydzdOY0gvdUxPN2VKM1JEM1NUblFMS1lUaXJjdHNvRVl6?=
 =?utf-8?B?TWpob3M0S2cycWQwMEZINjk5aDRxS2xkOXdPL25HaFVDQm4vWU9mNmd1K2VR?=
 =?utf-8?B?MWFuRTRrZnduaE5ITFNqb2xiRXlIWjl6SFVXWktZYXY4ajkwc2tMSXZkQUgx?=
 =?utf-8?B?cmt1THhhV1JRbWtxaTdFcm1TN2ZGWEVlblpPN2hQcGtyVFJ3WCttQzV2RG9R?=
 =?utf-8?B?a0VhSnlUVy9tU20vakxJcTJBZVJYZ0JKby94MGN5NEZIOW1mWU4yWENsWm0z?=
 =?utf-8?B?cEdvTDI0M3ZRLzFPWDUvek9FMUJLRzFLbk5WNlVVSTVrRzlRNmYxWld6dThE?=
 =?utf-8?B?N1dpWlVZMVI2U1lnTVFZR2dzYmRUbE82K1dtaE11QVZsblR4clF4WjI4Vkdp?=
 =?utf-8?B?dWx0UUh2N1puTmlPUzNmbEZVbExzb21ObDZRQWlrdkVXcDVzU1k0dkM0T0l3?=
 =?utf-8?B?bVFvbzNHbm9nYjJwTEFDTHVLSjU0ZUdUTnlDc2FsS2xtTm5RL3N2WFFWQWh0?=
 =?utf-8?B?UUNmTGxjaWdjY2F6MlVtZDN1bnAyWEUxZjAwQjZESWtvUlF4aDZOd3ZNMDB4?=
 =?utf-8?B?OVROUVV5SjRjaUFjazJQTXNiN2o5RExFVmlaalZJVHFnUnhJQlgzeUpwU2FP?=
 =?utf-8?B?UE5xZ21vMEtNaTdUSCtMUDRBSDl2WWtHZHpuQUozeTUrV1o0SG41ZFFQSkRS?=
 =?utf-8?B?cmZGZE5jdHRibHljbWNMSy9LOVZrd3ZZbUh0R0lVV3pyaVBqbDAwOVVCWnRn?=
 =?utf-8?B?YTB3WmZrLzEzNkx3Y1JRZEpZLy9KcDJENlhUUStnWEprNVVKamtGVE4xSWJi?=
 =?utf-8?B?NFNHTGV6eDFESXR3WFkzYTB1Z0wvMFAyUVBUWU1ydzJNVFJkQ2FTN3M1cjFO?=
 =?utf-8?B?elo3V1dwbkU4L1BFSHVubU92YU51c2Y4a1ZnUkNKYkh4ZDdKMmdIWUcvMENN?=
 =?utf-8?B?Wk1YUTdmVnNSNmhHZU9pdFllS1ZoZWNGUHpOMEhpamV4cmhtWU1kckQ0WVdJ?=
 =?utf-8?B?aVpucjJoTzR1bmgxWmM5RWoweXlPOHpEZGo5aXhmZGFqWU53dlJXVUM0eisr?=
 =?utf-8?B?MU4yNW9KZk83R2FmUHNWSEg5cDV3dkM2TUVvYUdRYTczT0U5eVgwbjJXemlh?=
 =?utf-8?B?L1ZDTkw2UC9YdTVGWFhHTXhXRFFUNm82SlZxc1RISUovckJ0Tk4rVFdNNGtw?=
 =?utf-8?B?MTZXak10T3kzbU9ZYy9MTWlJaWlBaVVPWFc4Rnc2TjdnWXZtRzgySVFZSU9k?=
 =?utf-8?B?WGJXKzRoZEM0TUsvZTcwYkJaMGhBbzlHdFc3RVJJUm9vYUlqQXN1a1J0YnFZ?=
 =?utf-8?B?clI3QldyUEhWMWJMT29Ha21vSGpnbk42QTZrcEdjb3B6dmxtNjNIdVlDN1hi?=
 =?utf-8?B?UnhDRFNFUnVVaWIwRC9TQVBXem1GYWNYVmtQYkFBdEo0WXFGenhubWhpRHFB?=
 =?utf-8?B?QmJNUzd3by8zb3pCRjl3NldGMFpGM1VLamdyVHZ2c3ZpaHlnU0hCNEJsK1d6?=
 =?utf-8?B?amhWaDhaUlVwbHFJbC9DTnhvUk9USkVpdHc1V3E1dVpMMFl5THAzUGNLbkJS?=
 =?utf-8?B?RHE0cTVqZTREMnhtTUZoR0IvNlhJOHQvbllLa1N4ZE5yOHVBQ3RvVGNqNlVB?=
 =?utf-8?B?Wkk5TmZGdC8wbXdkV1VqYWRoUjRPRFFFcGJwSmlkMG1OSVV1S2hERkZDMFlY?=
 =?utf-8?B?ZU4wQ1pRcXU0cFhXcDMwbFI4NkdDazhiTkJ1d1JJSDhCMXRVcnJLalFIOVg1?=
 =?utf-8?Q?wCfjboF5a4gB01H7i3xgpY4oPgk1q4euDFp69xg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe054cbe-d563-40df-f9d0-08d90a8ca5ab
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 21:29:04.2455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2zwjhEvXphD4998zifbG+KGWN0vPyQtjCXGwTuiSnw+dwkdYzbyvVIm/2vSvmqngv+SjM6WRuRRdwBzbk1kMWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/27/21 11:58 AM, Borislav Petkov wrote:
> On Tue, Apr 27, 2021 at 06:16:34AM -0500, Brijesh Singh wrote:
>> The SEV-SNP builds upon the SEV-ES functionality while adding new hardware
>> protection. Version 2 of the GHCB specification adds new NAE events that
>> are SEV-SNP specific. Rename the sev-es.{ch} to sev.{ch} so that we can
>> consolidate all the SEV-ES and SEV-SNP in a one place.
> No "we":
>
> ... so that all SEV* functionality can be consolidated in one place."


oops, I did it again :(.

Let know if you want me to send the updated description ?

>
> Rest looks good.
>
