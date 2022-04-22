Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A111A50C43C
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 01:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbiDVW2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 18:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiDVW1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 18:27:19 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364261CFFBA;
        Fri, 22 Apr 2022 14:20:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzuNYQHcdme8ZZFRW9Mw060vWHVG54wp8APy6amkaMt+JVEzD+aXc1pX5Rs4oF8XuaJqSqjc6zok3nA2WzubKY0JBywzPjKxk8z0TRmzEZpmgCd6FjELdLeUWFWaeuAfsTwpul0jszoJZ2Nk1NtE50e7fFAEegGIbdqZifO2zBHL1vOsrswvF17FEHib3D4H4J1P4OICrl/m6HcHc9K6x22xIsgSySks13bHEjrQaewylvmypvXTg48L9mUQRYVO6Xay0XZKqlpiGmVm11FP0Kk70PgrXt70oLl67vhDrgfvFJN3tFYEERvXBGDrP2pj388VcYAJ/ujWdZj3fpZTsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Gl+JpD3PC7wVLwq+Rk+S9FN/ymuoouajxzal7JkpBo=;
 b=Seo6DfWOFYRJjMQ7zj7yk1xxqkF7PqHYwTs6z/CpcRo6KI6kJ4Aq4JRfctqDh/f8SZkFGFMLfgC8devb0E5sWMv8ftgByWaSM4AK/RVtj7vvWHYP60GwU2QHfFLGG/4GrbSRGfmQp1YG6WM/7yL3V7SlTOdb3pE/xuQhkC0gejTVz/Koi4w8SpmVvWPV3fwHSrGCRp6rRLCG7zzJQZ1+0E79j2vlEJsZqFAWp9wJdd+0JG3m+0ttmV2nmbhtnWoCxZmshPaKGihPpicGijCyHyYgPAsiYR7lrB/NADrAguy6BIBhxCvsHPTTnWhUs7lTg1fNe2xX9/bwyv9cet1i0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Gl+JpD3PC7wVLwq+Rk+S9FN/ymuoouajxzal7JkpBo=;
 b=GC4sck5tzjzkkuMm6OrsBQtTwUgsUXuBj0p+uxMaJtyfhd1Hqtj5+8EXEkDqNAKKGAXkuXtaExY2gnL9AbjufHORgB/TW0trQJ/OMsd3eHbCpZz1kb7MnZg6vvXfbVY5RupuuW3nS+pqYpmbHl2MAflCgyLJ7ZpzLSa0yC3Ho+A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BY5PR12MB4275.namprd12.prod.outlook.com (2603:10b6:a03:20a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 21:20:01 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::781d:15d6:8f63:a4e7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::781d:15d6:8f63:a4e7%7]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 21:20:01 +0000
Message-ID: <1f644aac-3fae-ca1b-76f8-dd3bd34bcef3@amd.com>
Date:   Fri, 22 Apr 2022 16:19:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Mimoja <mimoja@mimoja.de>, Paul Menzel <pmenzel@molgen.mpg.de>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, hewenliang4@huawei.com, hushiyuan@huawei.com,
        luolongjun@huawei.com, hejingxian@huawei.com
References: <20211215145633.5238-1-dwmw2@infradead.org>
 <9a47b5ec-f2d1-94d9-3a48-9b326c88cfcb@molgen.mpg.de>
 <ab28d2ce-4a9c-387d-9eda-558045a0c35b@molgen.mpg.de>
 <3bfacf45d2d0f3dfa3789ff5a2dcb46744aacff7.camel@infradead.org>
 <ea433e41-0038-554d-3348-70aa98aff9e1@molgen.mpg.de>
 <efbe0d3d92e6c279e3a6d7a4191ca7470bc4beec.camel@infradead.org>
 <74d2302f-88fc-c75c-6d2d-4aece1a515bb@molgen.mpg.de>
 <e3ef8236-344d-e840-575c-a5fb1450a13b@mimoja.de>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
In-Reply-To: <e3ef8236-344d-e840-575c-a5fb1450a13b@mimoja.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0064.namprd13.prod.outlook.com
 (2603:10b6:806:23::9) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42e92a01-021b-4244-7ae3-08da24a5dc4d
X-MS-TrafficTypeDiagnostic: BY5PR12MB4275:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB427543EF079600804A45699FECF79@BY5PR12MB4275.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l00f9hf4MUuviHyS38Sq9+F57QxxTe7GLTHWRmPzljFWz6l6P99I/nblhntL9Sb6V6C0+ng8xgzGmiBkGF3D7lL84PrWUwM1zYaLSBjp/aDr3bfHY7zKortkId4KR0ZVvfQDBXmbr+9GGxcfhIw52RdXxTz83q8PA4nIWau4biF8gzxxbdnZaTymAk1ZhoZtSS0jFvTUqMKod+eLYOEQYuzgOvJU+s+jbHxVyzCoeioEJwqHM+Rqk9PMC2Bp1vpTwqB1pYu8I/SDwZnszWX7BSG9grz6ToZ9lNE44bCDQnqcCv7+WqWFlbKCYIuN6VYJg4H0ivZxGSraUyVDzIr2LP2pPh332Ul2XkVHOjwIffe2j60ZZKBzh0eV2DmPe48tC2qxnSzpM5yRHL+cNb8lyMSgT7654mmdOVRXMHHT91l4BKDI1v1Fskg2HxHSKqukc4Oy/GHk9xaEHcBf3qN4kOKG/aYNP5dgWHlycoEAFKWBJB51Vo9tuSDp+xw0YibAeTLsmfrQpzMvbrh/Ukb+umzXw9h3XOA0TWLMA395EGSLAhMwoRjsrh6ElxTmMnRuFnnFy52THfYkipC+GLu7rUOpaSugOBCjM0y9+ssOUAEirOvNs5BT7p8KjZXeDJny4uHN62Urc41hld3dzH8si/0LRTYEDNa4Ze3bMdu2Ho17Gu4rZH4VbWpzlbQmLML0IES9E79pU6MVz4VpPC8k2+aiVSWy/oC7nZk0WihJzR+T1jb3Dm/8VXdODXmJ/p8b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(66476007)(36756003)(38100700002)(86362001)(8936002)(4326008)(316002)(66946007)(8676002)(66556008)(83380400001)(31696002)(31686004)(26005)(54906003)(7416002)(2616005)(508600001)(186003)(6512007)(6666004)(110136005)(6506007)(53546011)(6486002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2psaGRKbDNNMXVpc2F0ZUpGNUsvV2NCY3VTeTc5MGNqNmpGMmhyRUIrbEFM?=
 =?utf-8?B?MHNzZkNYT3R0c3RSRkdBOE5zZTFjeTJ4OEVDVmJ4VTY4Vlg0b1pSbnFIQkZB?=
 =?utf-8?B?Tm1WcFhwaVF2SE5NZG55MWVRMUxjMXB0Ni8xc3J3TnA5eFlQd3JDdEpySmdC?=
 =?utf-8?B?TTY1RFJRVjhaQVAzSHVVampaWW1yTWloMlRsL0F3U1Jkek0yNnZtZUxMeVkr?=
 =?utf-8?B?NkUxdWZtaGRnQW9GelVNdXBwajRyeDROMkxSRHI3d0Y3cDZ0bmVlRWFzRlA5?=
 =?utf-8?B?V1E2ZGNtMjA5Q3phUGdrMGZYNDJMOUFoTlNmZHF5UjhNNGE5VjVWL2ZTd1Jy?=
 =?utf-8?B?R3ZyV1J4Skg3WXJwblBUbHhJWTA2L0RFU2t4ZUM4VW9vSHRab2MzNFh2c1V5?=
 =?utf-8?B?RWVNdElsTnN0TGhjQVJXbFA0NzlWbnBJcFdhTFRhNVVjU3ZGYzFPNGYvc3hk?=
 =?utf-8?B?UEEvVnZNbDQwN3NxNjN2Vm1Wd1lwemt5Wmh1U3NuY2dBUXZwU2o0eFNoUkpy?=
 =?utf-8?B?a1hkS2FXMjZ6UUFTQnVLdExZUVJpclJYb3NrVVB6dkxINDMxd3g3RjZaTFNj?=
 =?utf-8?B?ZDFuTEk4bUdIZGFySkwxTVBLK0ovUS92Z25iWFk0MnVEanhZN2IwQVcwajBz?=
 =?utf-8?B?azFaK1hSRnNxc2JKU1c0TnBOTlhCQmFUMkN5MzV1bUhOUzgwUUVycTFPejBr?=
 =?utf-8?B?UG5MT2Z4VitUTTlXS3podFFjOVpGcUJ6SUM3TjQ4UG13ZGtVWkc3K0QxbjdI?=
 =?utf-8?B?b1VZbW9GVnBPSnlOcTRnNUlxd0ZpM0dQazVId3dYT3FlVVNOejNGdS9XdXNn?=
 =?utf-8?B?cUdQUTJXZTBJWnFzYW9MMnRWQ1VZMFFVVjg1Y1ZUek4wbXlmUnB0ZDNRR1BL?=
 =?utf-8?B?LzF6SW5HVWRHYjg5enh2ejlNUXJrUEV2bGtnTEp4YUhvR0ppVk9pSVBSSS9q?=
 =?utf-8?B?cldWZEV3UVdrZWE3eFEyQkR2NGVQZTltK1hHQVFrd0lvc20xNEV4M0RQTVdi?=
 =?utf-8?B?L05TNWUwSDM0TlZwdmNWK0x3MEZ0bzA2Q0VGZUY1Ti8wTEtFUjdlUFZtU0dk?=
 =?utf-8?B?K0JhQTFJeTNCTHZwUUhjVVptUElOMU4wMk5kbzNmTXVKTDI2TXNyd1djcUI0?=
 =?utf-8?B?UTdIdGpuczRZZGNZU2w3cXM2Wk14MzRzZFBxMFZhdWl6WWxXTjRRZ1NBekxJ?=
 =?utf-8?B?aExQZVA2U0x1WUNBdHRZdXFwWjhiQllYTm9wcGdJMEYwUlJzSFl4T2xkSWlO?=
 =?utf-8?B?TWtudjN6aHp1a254SVlzL2g4eExpMld2Z3RsTDVJdHRGOS9HWWxBZGc5d3ZZ?=
 =?utf-8?B?MFFIQ2twK3RTSXlCZ2EzZk5zYk1zZ1lZZ0gxNVBIa3d5VEJRdGtoQTlCeDJw?=
 =?utf-8?B?V29ocmJuaklEeFRaSmZoNExSbTlRZmFiVUtGSVdpZGp1YmI4d1ErajJGYndn?=
 =?utf-8?B?YkxJYWxKRUlQbWJTNVBaR0JVRmoyTEI1NzhhSmRLaFdYVi9SUVJMUStablRW?=
 =?utf-8?B?Tk9Hc3ZRNE1adGMzbG4rZGhGQ2xVSXY4bjdMTmc0TnkreWpNaitrZE55QU54?=
 =?utf-8?B?Y3BJaWxaQXFteVF5TEJWL3VsbUxLalNHOHdnaVlpSmtjWXNXWHFsVTl4QnBW?=
 =?utf-8?B?aGQxUXJnWWQ1ajBzR2pmSEZUM0NQRXJURWMwWVNnaXlGYWwzajQ3OFB4dTkz?=
 =?utf-8?B?L1FLTjczbi9kc3JWaFBYWUxSdGFJNDFaM3JaR0xlaElHd2crMUQ5YXUxVVRU?=
 =?utf-8?B?c2R2cmJOSkgxdXA3dURldG01b0hmUWdheXovR3U3S3o4QWJ0cTc3dm1kRUkx?=
 =?utf-8?B?MjUxUU9JbEZEVTgxdmRaeHd3N2xPaUR6aG1EVURzL296NkdIVm9PaDJGRjYr?=
 =?utf-8?B?d3NPZXZ3VjI5cVhGbmdsVUpFN1FwdkxIeUdmVm1XMzdRY2ZsNE9IbHVSaW5n?=
 =?utf-8?B?RU1RZGZTYTVPbU9JY2tnMkdVdjM0MWRYejZuSlVRM29XOXlGNW9IOFA5Rit0?=
 =?utf-8?B?QXh5MG02WS9TWGFKTEE0cnhVa1JXYmx4aUZsWkN3dWpTQUFFYjlSeGV4WGVW?=
 =?utf-8?B?SzRNREVTTVRPbDAvSnBVeWRaSFZtdHBjUXJ5Zm15Q3phUXpzTTJzWnE2K2ty?=
 =?utf-8?B?UTAwMlpDeWl3dXR0djVPUDBvWFpxYmVYSWw4c3NlanFneGxsaXArOEkwc3Bp?=
 =?utf-8?B?SjRLbnA4TW1YN1dROG1IbGtNeGRFNFpQWmEzTXlWZExCQkk2NG40cjFNcUFp?=
 =?utf-8?B?amRrUGRxRDAxemdWYUVHOWtFNTFaM3UzMlhLV2NuQ0V0QnNZYjdsZmRSZFU3?=
 =?utf-8?B?d1dLc3oxQlY1dnJRc1NzajZjL1ArODJHNVloNGpFUkdTR0FHZ0swdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e92a01-021b-4244-7ae3-08da24a5dc4d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 21:20:01.3114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OsqNcmrBuR8WpYKhUjjYx+nYHswPH99VCrNj44z4b8tuIL6qNH/IWoMUzyjd8j4K9jBalFiuaiKpusfozZi2Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4275
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/22 05:00, Mimoja wrote:
> Dear Paul,
> 
>> Sorry for replying so late. I saw your v4 patches, and tried commit 
>> 5e3524d21d2a () from your branch `parallel-5.17-part1`. Unfortunately, 
>> the boot problem still persists on an AMD Ryzen 3 2200 g system, I 
>> tested with. Please tell, where I should report these results too (here 
>> or posted v4 patches).
> 
> We have confirmed the issue on multiple AMD CPUs from multiple 
> generations, leading to the guess that only Zen and Zen+ CPU seem affected 
> with Zen3 and Zen2 (only tested ulv) working fine. Tho we struggled to get 
> any output as the failing machines just go silent.
> 
> Not working:
> 
> Ryzen 5 Pro 2500u and 7 2700U
> Ryzen 3 2300G
> 
> while e.g.
> 
> Ryzen 7 Pro 4750U
> Ryzen 9 5950X
> 
> both work fine. We will continue to investigate the issue but are 
> currently a bit pulled into other topics.
> 
> Thomas, could please maybe help us identify which CPUs and MC-Versions are 
> worth looking at? David suggested you might have a good overview here.

Sorry, but not knowing what the actual reason for the boot problem, I 
really couldn't give you an idea as to which CPUs and/or MC versions are 
appropriate to look at.

Thanks,
Tom

> 
> 
> Best regards
> 
> Johanna "Mimoja"
> 
