Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D026E87A0
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 03:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbjDTBty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 21:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjDTBtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 21:49:52 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9598B10C;
        Wed, 19 Apr 2023 18:49:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FLUYJatsQStxawJjzhHZqu/IUmrYle/WpcFHETrx41tuOCyHHJ+FMVR3zmr7h/9rnzCnPznKMk0iJxoP3FHzdNT5RXCT2zwo0mSM2N5pTgp0PznyGo07iIQ3bbtaVW615lBTn8El+CdqqVp6DBETzcbAGa8iUC1h5GLKyN2v076AVtyKsi6GzjoR5Rr+qHWoRsTeurRo6cL/lHEjo+l/sjNYe0SXnhqMDeW8W1ATfA3LeW/h91wB3RovqQKJQDgRLVgeaYc58rrRHRS8LQd+IBgSxVmkusHlHL+LS2bSLiuW3B/9LPyY2/b1UGzIkequfdtqCTzO4g6BaxTQZUSFeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z8GE0NtX2mA7BDLgPedM7Jm9iPYnFruR6R93/x92opI=;
 b=KmoD2el1YT+ISk4Hc87AdRdWk1do57JVKjCjVRS9uC8hIB7JkiiQ9Mcosbq/tMbz9a2sqU1HyWvMzdfxnIAmqR26HsUqhYfOKld5JKSLe9hK6q3qlNWAd25+P3+rxxGGYiateBVzqH1KSKzTy0AHmRJaB2n6eVBcNWFMIohrVDbHq54BK6Z+KXULtYpj8hqkGc6N10bQAUhnvcOuKWD/29V0eAyvjYFjuUbeVWkkPrn8BI0wTF1ZigQ2KTWZkPw/7sreEz5ZovU8cDbYcmyV+Pu0XdUd3e4deR9pDBsf/4anfmlkLChk0th5nYDDC5KQ4BPXNxW4atWH0KebZu1pcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8GE0NtX2mA7BDLgPedM7Jm9iPYnFruR6R93/x92opI=;
 b=WnMnD7kmAB8AaTTbWxgkb9QCAcqJcHMD2utrsS/X8MzbeF+6DL2BCTov6uDmvuEzVMccwZBXQCmCrOQMkAH46hu7xwZre5ljHIiVYxSBqpLQJ37DjfTgrlajR27Ml9kJaTLBR98Alp0YUYAZHUqWsUz2JXvR5WAd2EhSl6dPKFg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 DM6PR12MB4545.namprd12.prod.outlook.com (2603:10b6:5:2a3::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.22; Thu, 20 Apr 2023 01:49:48 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::863a:5f29:1e76:db60]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::863a:5f29:1e76:db60%7]) with mapi id 15.20.6298.045; Thu, 20 Apr 2023
 01:49:48 +0000
Message-ID: <6a0cde0a-e1a4-9119-75fd-12b7c921b5f2@amd.com>
Date:   Thu, 20 Apr 2023 11:49:32 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH kernel v5 0/6] KVM: SEV: Enable AMD SEV-ES DebugSwap
Content-Language: en-US
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>,
        Borislav Petkov <bp@alien8.de>
References: <20230411125718.2297768-1-aik@amd.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20230411125718.2297768-1-aik@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0116.ausprd01.prod.outlook.com
 (2603:10c6:10:1b8::12) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|DM6PR12MB4545:EE_
X-MS-Office365-Filtering-Correlation-Id: b6148c90-927c-4ed8-7dfc-08db41418597
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sXCDYbGCUiwEbDsHnupZR3YG3P3ObvxVer9fTzMScBaYO1m80BixBkQEtJOOgzyl5SklGpmWhmyEirbcrg2n//AFnydyDxZSMuiawYBowxn1Y63SKayd8/VTxwydujMz7UOWxF1httknotd2scmb+Cn8UP+fygRe9Ob1kncfn/C6cDt+711gkAPSncN9rzN8x8gAv7RRDohuSDyaXwr/ym9l7iMHPdyDtIGv0fFZMhGFa2vDY8QyecxLGfR8CRm4zpm99PwgbAZDvww331LS98rcOtvZ3n/aSVsENM2kf19Xckkp5NYL63xrjo+yjozsUjIJDhN1jhmZHXSFQiD0QBV1hxmsqBTWk/ENz6AyBMFHDqjzFXE2zXf+WDlc/QWThZt94tKEPEDu9QAn++N94tHfvmaEIB+VzQLPjAdThpUKMgQYowToQjfZi6vbTfonzmwyS+q6DYWtDhG5xJ/2JKjghCYG9fzfHaayGa3rE0ND/NW82ufBSCH4bZM65FoW4k6llU7Mf3i8sURSVZ1DbyGHzewenI7jiT9G6aNfo9I82jD7Y4JHSYYzVH03rA5UObOvOO7m/GVhel7ZwP1Zz9QMX4CsA6KpxP9Ack68J4vczqqVzpTXIT8bTb8w1XcJqLILpT0O3CoxfyfV1IybzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(451199021)(31686004)(186003)(6506007)(26005)(53546011)(6512007)(6666004)(6486002)(31696002)(36756003)(83380400001)(2906002)(316002)(2616005)(4326008)(5660300002)(41300700001)(66946007)(8676002)(8936002)(66556008)(6916009)(66476007)(966005)(38100700002)(54906003)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlJycHd1R091RjRTTnBidXZuelNrUk1EVWFMMnA3RWhLTGdoeFVuSzFjdWE5?=
 =?utf-8?B?cEhsWnNrOG10NngxWjhhOGNaR0NYVTVNLzc3MlZyd1Z1UjlGTE1NcDZqc3g0?=
 =?utf-8?B?Ry9EcCtrUHM1RXhyMEc2VkltTG84OEhkQzNJaGc5eWVPNmxaSHFTZDQ0cGIw?=
 =?utf-8?B?UWcwMXMzdWIvV2IvdTJ6dEI1T3Bnc1dybUNCUTFtQTI4QWIxaXJnVUNTa3VH?=
 =?utf-8?B?MTcvZ0M3WEhTS1NmYjZmNGNvMDZJM050dFNxY3FiNHQ5OWFQdnVGSmVUYVdw?=
 =?utf-8?B?bXpQNjk5ZDhzSWxHdWd2RmRZTEdGYVlnNVFvSEJFVnFEMFZMTDBrMWpObnl5?=
 =?utf-8?B?KzBXYjRmWThlajJDLzJOcGZTMW42cHVkbmhBRVJZdUdvTlU0ZGU2cXZKbklO?=
 =?utf-8?B?QVMrcFdoVlNrc1RoV2RDOVJKZVBUWTVBRXd4N2dhcWpObXJoNUo0dEExNVZr?=
 =?utf-8?B?K0w1N2k0NjZlR08wTnZmT3BBbTZ2UFdQYUtHNW1MMXhvUTV0QzBkaHpmWTNl?=
 =?utf-8?B?dTNjV1ZTTzhqd3BWakpoQ0tDZzZ4Vm9sZkY2RDh2WFNtUUxBeFNvcFdIS2dK?=
 =?utf-8?B?ZDYwNm5ZakF5ZWxBOUd2VHY0Nmd4akJoblhZSTdaZjlmYTlNK1JwTmkxdnR3?=
 =?utf-8?B?VEJpVUt5M0JYZ3Y5M1JEZGJMUHpDRDZZVGIvUFMraTl5Y3VNdGdxN3hWRUlx?=
 =?utf-8?B?WHQ0YUtyWU5pZUFlTzZJRDZNbm9FU3JySzNxL0hNSllGNGF2YVBDREtPK1Qw?=
 =?utf-8?B?M0FZN0dmUGFiN2prTDVCYXlOWjBvYUxuNkFHUWdTOFlRc2Rzd2IrN1hPUXVm?=
 =?utf-8?B?bzJwc1gvUkdBNjlLSHhFTG9RWlJlQmtaeHJOSmdZaWVDK3BKa0JwVEZkc2Jk?=
 =?utf-8?B?VytrR1BPZks2a0dWQVRsdkpCU3Raa0ZpZDRWdDMyWnEycldxZis1NWhXNWNW?=
 =?utf-8?B?M2lQMGV2ZDRxa0g1V0VoSmJzVXk4UThFWEZQVVBSQk5tUTIzYitodDNhcERU?=
 =?utf-8?B?dEROWU5CaE80WTNPNDlWY0NXSnE1bisxY1JDZzRuY3Y0VHJySGlvUVJtVUps?=
 =?utf-8?B?MHRETlZXNzB2Y0kydkZvc3VvaTNDZmo5SXQwcGNPTElzdXJ0ZHV4azR4TlVw?=
 =?utf-8?B?SGJkVkRFRWJHcUhTZXIyQk50UGJsTThBaUowVnhIdWs3Z011dzQ4VFJ2Rnpk?=
 =?utf-8?B?bEdMUjZnbFVPbExBb0xyTGFsOHNkN2dlM0pvUkpjaml1ekhqZWNqbi9ERmoy?=
 =?utf-8?B?NE5TMVZDc2VXRmpkZFRQL0l4bEhqTWUyWDNJY0JoUmpCc3V5OGJnU0FYdE53?=
 =?utf-8?B?WStwa0xQRURLbEJDemd3aEVMN1pabDVTYmJzZWhoMGxNQ0Y1dHlsb0J5M0xv?=
 =?utf-8?B?Q1NmTU52OUFoaEYwdkEvNWFZZmZYZ1ROYXp5QkVlS1NzU2U4T1V5bEY1bThC?=
 =?utf-8?B?Vld1MUNPRWR2dklkTjNEOURkaVBUYkVTeXhhMm9oNE0zNW80MEc0YTVCMzBx?=
 =?utf-8?B?MVR5eTg4dXV1dGJLenFIZEQ0VCt4bVhJQlpEY2IxMzM2WVZrTmRVRTlkNjZt?=
 =?utf-8?B?ZkRuc3ViYTBHM0FqZGRzY1d4a1lVUDdRejZ2eTcxUG5IY1NSVFM1LzU2QVNt?=
 =?utf-8?B?NkUwcW0zMHg1bGNuMFhiaVZ4ZHJ0SlFjWUFDOHpVaURhUXJWVk5yRlJUdDIx?=
 =?utf-8?B?TTA3VHlrWW9XUkZXYllna2VIbFFSeFd3U0VmTDRvTWluS1hqUEQySmpBR0to?=
 =?utf-8?B?T3FtZFpRYXlQT2l5Zm9yZEoyWnJHOXJPRE9DTldkbmJoM3ZYY0RQdTFiY241?=
 =?utf-8?B?MkZzZEdpLzdBSExBWlQ2bkxwVWJIaTNrNDdja0xXOEpsSUFSSHdOQmhaNkhU?=
 =?utf-8?B?aUYwS05VTHQ4aEY4cXV1aXZBbG1Qc2NuMmlkWGk5WElVRjlzQllCaUVCQWZ4?=
 =?utf-8?B?SmlETzhwWCtMazNhWWZCakpZZlpsQlVTOFdlRHpaaURBWW9yemxIR21kcngv?=
 =?utf-8?B?NGhuVVp3aFJqRXd2b0xGL0txNEJEL1E2QUUyQ2pNbXV6NHJLU3QwKzJEQ3F4?=
 =?utf-8?B?S2p1c0tGM2lSVGpOWVRvUkpMN1pneVBwNGs3ZFEzdkJ3R0RsZzI5SHExNklO?=
 =?utf-8?Q?vD31tkKGEQJgqXUkO2Pma05ln?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6148c90-927c-4ed8-7dfc-08db41418597
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 01:49:47.7997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f8xFtBXf7/CnjsSWEUx2psd1NIA/D8pOvRCdWcuuWNsW3BW49ujP3z73ZP0ZbzbAKLJJWNk7XD7HTZt0xKaE2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4545
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/23 22:57, Alexey Kardashevskiy wrote:
> This is to use another AMD SEV-ES hardware assisted register swap,
> more detail in 5/6. In the process it's been suggested to fix other
> things, here is the attempt, with the great help of amders.
> 
> The previous conversation is here:
> https://lore.kernel.org/r/20230203051459.1354589-1-aik@amd.com
> 
> This is based on sha1
> f91f9332d782 Ingo Molnar "Merge branch into tip/master: 'x86/tdx'".
> 
> Please comment. Thanks.

Ping?
Or should I relax until the end of the nearest merge window (May 
6th-ish)? :) Thanks,


> 
> 
> Alexey Kardashevskiy (6):
>    KVM: SEV: move set_dr_intercepts/clr_dr_intercepts from the header
>    KVM: SEV: Move SEV's GP_VECTOR intercept setup to SEV
>    KVM: SEV-ES: explicitly disable debug
>    KVM: SVM/SEV/SEV-ES: Rework intercepts
>    KVM: SEV: Enable data breakpoints in SEV-ES
>    x86/sev: Do not handle #VC for DR7 read/write
> 
>   arch/x86/include/asm/cpufeatures.h |  1 +
>   arch/x86/include/asm/svm.h         |  1 +
>   arch/x86/kvm/svm/svm.h             | 42 ---------------
>   arch/x86/boot/compressed/sev.c     |  2 +-
>   arch/x86/kernel/sev.c              |  6 +++
>   arch/x86/kvm/svm/sev.c             | 54 +++++++++++++++++++-
>   arch/x86/kvm/svm/svm.c             | 48 +++++++++++++++--
>   7 files changed, 105 insertions(+), 49 deletions(-)
> 

-- 
Alexey

