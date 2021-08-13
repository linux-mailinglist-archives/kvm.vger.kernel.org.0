Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF6E3EB951
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 17:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241286AbhHMPcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 11:32:55 -0400
Received: from mail-dm6nam10on2049.outbound.protection.outlook.com ([40.107.93.49]:12737
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236719AbhHMPcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 11:32:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/UyfMIZLxxS0ltpkdMaOq8zqaA3ItGfCWZih4URD74TwYVJ6npVz+DyoFinwaJk7dNB1JG7MqyJ2rKGECE/cyikNok6BHOyjQsdaExUV3xoPCEKL00WwrWLMrQMa9G1JQISm380cIVdM/c2y7e6IwiQtROVX73OpgL4KzVJ5SSukmUTUKrUSaI41HGcSg0uOPNXZCJTHzweIWFYga7jsSdQrtFVUTTzR1Vb6pVO1WxoybvblTjAP5LDfjA80stu84Tu/tEo8kE9fuxJ351Xfd3KQhoPgtnfLYcre8enTpNKZBCbh3mgGIEVvTnPL0tyGJxvfLl4X+HSFMKqcqkpDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clneJU2ChwYD2sWkingYnU+SVAP/tg51vM3eiC7bzkE=;
 b=Prz5+ysZeJy5epTY6cZy9LaKPjx58OjXO6ofT/lSEVw/gmRioAfLsNOodGkXolqOfFARPZC9kv6cjIYjE3kvDlQP/f9TDuaJ3vBYeWgBJqGje+J3WLJAwaxhHHO0XCvXq+JY7SKU7QuAlxm0B/OFVKQexFGJcUkM1bNv28bfE6IMIg6sIbBfj1w2IPxyv8ZWS+0GX23Z3wpCpczJCeCvNKYP4o9WrQkO4yvh9IwgQd1Fjsi4Hkm8qkOZ2BORmD2zTKZAl5yvQqfDV6ttYJGlN/4SzL8bSscrwtNNptInDM10yh/4RaGTZhN1cYy+950ofgAjngcxtvuNRy2UuDt3lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clneJU2ChwYD2sWkingYnU+SVAP/tg51vM3eiC7bzkE=;
 b=vXiH0vSLGtJxKCo95LMPuJaqFM+cSexvAlpnBkG0pURHsSlJe/CUeW7RFufhAa56sj/qceSXphDwQuTR15sCYujQscrgVq9US0k0p6Ar37wR2XkE1IcDMSnEi0eq9L2cII7G2EnjZsyC4YnJFm7kR4mQ6I2IIm40pBIfcHDQ1Ko=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MWHPR12MB1872.namprd12.prod.outlook.com (2603:10b6:300:10d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Fri, 13 Aug
 2021 15:32:26 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e%7]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 15:32:26 +0000
Subject: Re: [PATCH kvm-unit-tests 0/2] access: cut more execution time on
 reserved bit tests
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20210813111225.3603660-1-pbonzini@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <3fe8d2c2-dc5d-06c4-6c0b-10b4da3a04d0@amd.com>
Date:   Fri, 13 Aug 2021 10:32:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210813111225.3603660-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0133.namprd11.prod.outlook.com
 (2603:10b6:806:131::18) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.0] (165.204.77.1) by SA0PR11CA0133.namprd11.prod.outlook.com (2603:10b6:806:131::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Fri, 13 Aug 2021 15:32:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9865519a-1faf-4a35-dc8a-08d95e6f8da0
X-MS-TrafficTypeDiagnostic: MWHPR12MB1872:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1872FD048C5836FEFA44970E95FA9@MWHPR12MB1872.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l1k8lSPTivtl2EQVhHt0GWkmI9vRFEKDi4Goib7zOP+w0U0GqNuSPgKhjczI9FThHxpIz4UvH7Jisn34IEeh1acnDRpVgzGd7R+M6ZQsfbHloWMyvoeDIEPxGW3D1RxawdTSQ2Xt//CKsHrGKIAEfGdofHW9P61VtVRq4p40js8CGwaX8nmW8wfB+SE4QbTgxVn3rAT0XWUVG2LS56HOvMYe2D4SNI5GigHcHrnZKresCPJltaQvpL002Ka62vx/f+DIwMR/nXX3/ju6fB1y/8I62bVnpgxXbDedW/kqLhuFbtOFJ9yn70u06t7fSvSInBM4UYWPPKgzz10rz7s9TLehNhMTIXEzci8EYYHyyVJXT+j00HkSuCUIdA4KKZD60CMsxNWMC6AtbKBPqqdBSTFy4X8+pCc5ztM7KAwtih2GdWR0jLQL0KcivBRdD4+iORAh334OdMvcAq1VWDbPvhYcAUX1AYThr65m3jvo+BvhBJMNPWf6u2BhYB4+T8ZjS+gBBA3toKcY0wzL14NK8FWw2xlb1uopbTqBE8YDHfrGQSRQy7v3HtjbUiMz+9Yumft2cnct+VGj/C8KNwqSGT6X/M6KxVaSj5vYZN6CA7nf+z4P+H4zuh+EiLok6z/J74Pnm3TIDxX61aAH7aGltwumNP/9aVPbTBog5PRJ4Cd3SCprot4lowWNWSctYMXCkiAbrALZ1Nq+cmt+cPAVqFbt3RL3YuBGHrm/tH4LiWJfVJGmJMANFLDa/jUYSqqw2VqKAp9qdI6MlkWKSZDXlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(44832011)(8936002)(26005)(86362001)(38350700002)(52116002)(31686004)(8676002)(186003)(36756003)(508600001)(16576012)(38100700002)(2906002)(4744005)(6486002)(316002)(2616005)(956004)(66946007)(53546011)(5660300002)(66556008)(66476007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDg4TG1rQ29jTlp5NnhRS3RETDR5TWdzUTY5eXp5TkVqdC9QeHhMRVAwTGJy?=
 =?utf-8?B?WnVvaG9xTUgvdHNDN1IvL1g4RGc3bWc1S0NVcHF6WEFHVlpXdmVKc2JVSGZU?=
 =?utf-8?B?Uk5yUlYzNHUzL3FCbHNqZkhlQVRzdStUS3Z5VE1JeXQ5TDEvRkxTampmYUdt?=
 =?utf-8?B?UzdEQndTMlhKdjJvbTM3V1J5c3o1UTkrWUJlb0ZJbzQwUlFFSkRCYzFaWEFU?=
 =?utf-8?B?bWxKUW9ySUMwY0IrcEdqMlU3K1d1dXR0ZWlZNjYyTU5oQmNKSHM2SUkrbzdp?=
 =?utf-8?B?Y0lCcEJIUVVzUFdiVS9LR3R0TGlCQUZIbmRzdXBucU96Yy9vbHRZNDdQMHZ6?=
 =?utf-8?B?VXR6VEhSVFhRZEVvVVptamZkZjUzVmJjWEdMcFBHWFM4QWlhVlZsSjdMTHR2?=
 =?utf-8?B?Sklub0tTYklUTThqWE4vd3kzaVZtOElzYmJJTm5xa0lDT0RzWWRGcTdJZW9M?=
 =?utf-8?B?cVZIbmZacnhPT283eS9kS2lzWWo3Y1MxTDJjaCtWR0VNR1ZvOGl3YytjNkMv?=
 =?utf-8?B?T2diRlRtWkpGNVViL3dIeWZhQWhXUElESzJtL3NiUFh2TzV6L01uaVk4aERL?=
 =?utf-8?B?dEtaYUxIaGI4ZFE4T1FBQk5Gamp2VzcvYnZXbU4vS1dxMXlnaDhxeDVHZUVG?=
 =?utf-8?B?ZkZvanF3V1NVc3RKYjExUGZRVWlLcVllZ0d6T1Jvem12bDl1VzhRdThIVFZ2?=
 =?utf-8?B?LzFiakJENm1ZUUlEZ1RlRjlmamJzTlZYUWNLZDNoaS9QSUIxMlF5cXFLY0k2?=
 =?utf-8?B?WDJvbGczSDg0YnRaOUV2NG5nQTdqelVOYlpuUURnL2hIeWh2TWZYZ3pOaks2?=
 =?utf-8?B?aUpobVV2K0hycHEyY2x5SFQySXdRQUo3ZGZ1TkorU1VmTjBEbVZ1M05xcTNS?=
 =?utf-8?B?KytYUEZTRWJMYnk4TnQ2NWk5TUV0bjVlTFZ5enNMaVNRalZhMnRnR1BEdEdt?=
 =?utf-8?B?SDYzZDFmTDdZUURaOER0SXo3RVczdE9WTEkrYVh3SWVYQUlSNTdLWDdBWkZp?=
 =?utf-8?B?Z2hPUDlmWW9VTWZWV0ljUlZienlNZE9FVW03N0cvdS9RSzBUOExLeGZXRUhL?=
 =?utf-8?B?R1UyWWtOUnM3bFZWV3VJYmI2WGRsZ1BsSC9iUHlkS29wTnFKbVRtL3dRcVE5?=
 =?utf-8?B?UjY0Nmd1OWFTWXowS3N1RndHTUtFR1poZVFRTGliZU9wZC9mbGtocEVtQzY1?=
 =?utf-8?B?bnFyTGVEZDFoTWtjZWtwQVh6TkpSd3NzemJCdkpHQ0I0QTB6UEtjbFArQTVI?=
 =?utf-8?B?b2MxUXY0Z2FXWTZ4Y0FKQklNTi94SXB1VTlxN2krQnpNSEhVVGdnVGhLVTEr?=
 =?utf-8?B?WVNGL3lZMGJMVVpDakM3WTlpNnZyUGhtRzNjR3lJaGZ6blRDOVIxa25jN25y?=
 =?utf-8?B?Y3UrMEtLNk5EN1lLQnpCbGxUYjc5anBESWU5YjVrWnJhM0haM1ZWZDFPYmFD?=
 =?utf-8?B?K1FPY05HaVdRcExjOVJNSkFZcUpYMUhTc3g5NTc3bUMreERRVjM1WkYvWUV4?=
 =?utf-8?B?S01RVjRZMXcxYVR6UmZGVXcwWm1pUG9mK1k5TDZQc0lDL2o4dW41c2YwbWdT?=
 =?utf-8?B?dnVMQkhTTDJid0x6WUVjWnRxbGFXNnltcjdCNGRURWlMbDN2NmNqTTV4NVRy?=
 =?utf-8?B?WVhWV24xOUZIYzU5M2FuempIZjZkUEJiNmY3RVlxUVltcDRvNzVtZXM0SGcx?=
 =?utf-8?B?eDhnelhJaDZrd0dmWnJDbVBXM3dsYS9UL2twUXc1azJlK3VSeUsrdVBRZ0tq?=
 =?utf-8?Q?ENNq26Mnl4dGrVRJjRGHOQMbvE/dPNLBfxzJhHB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9865519a-1faf-4a35-dc8a-08d95e6f8da0
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 15:32:26.3083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9fxf0CJuDpHRzpBZtjcX//PeVFmNynpLRt7tPwxb70wwpoBay5mnJll+baFgiAfR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1872
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/13/21 6:12 AM, Paolo Bonzini wrote:
> Cut execution time by another 25%, from ~4 minutes to 2:40.
> 
> Paolo Bonzini (2):
>   access: optimize check for multiple reserved bits
>   access: treat NX as reserved if EFER.NXE=0
> 
>  x86/access.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 

Tested-by: Babu Moger <babu.moger@amd.com>

Looks good. Number of tests reduced by half.

Before the patch.

#./tests/access
enabling apic
starting test

run
41287685 tests, 0 failures
PASS access
===========================================
After the patch.

# time ./tests/access

run
28753925 tests, 0 failures
PASS access

Thanks
Babu
