Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13155FF570
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 23:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiJNVb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 17:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiJNVbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 17:31:53 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B117531DC6;
        Fri, 14 Oct 2022 14:31:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3xdYcE7uTnge03/l4N2vU3jcGj/vTl2GDvHeiJzApGbbzUp0XSt9RmfGyteSOhIMAqBFRxOKJC/3VTX/7kMpx5dp5ZrvVKiseKrQdT1TlxEC1v67BLHAvBM0qawyXlFylTxeBXNUbOXItTY62g6BPSJw+/c8dnPrW7GBjMwIHihnOLZHVEfpPItxYczFyJx8DmdpXoPUep4Mk8TvCicVer1d21wK53Fm32p5eE5gVajTQ4S4TGNgP2x2JKvo5lDK9WwZFmQMUdIOGbadIHaktgsDsSwrqWPXzF1Hrhu5T3qj85kp7DS8O8xbq1pMJibd5eQA+SgwokYbeTrIpH8vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M3GyVn3QcoEbANDuf5loWPqQW7uLPAxqx0xcMbsO3D0=;
 b=fxWX/YAFcIII0OX/K0vgY3j3z4hn+sm8vQtLu+jIuwXNTqHm5nANtmdE4C6XzX2RRwbsvvxOa0DcL8vXH1CZ8gN/gi91oBfB3XTckFurEK/4NoiQoOdYn9NLIb0SMUGtW3JN9iAKnTNFkBRGpCsN+EyRuJB7LtfguY6bZhUxWU37B97Evcgd1NuezdBhUF/C/2KFQCtbgaDTGHazF0oywZodXefIC8ppsrw351BkXzfttzgYSZ2iBN4ZHpnQsC7cPTwQKP5QK/MIKJUx8goR0/5re9otRdULoAOv06cdVt7I1TYPn0xvFweidkRyGYAdnGkquOn3TWS/D5Lz8rBOEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3GyVn3QcoEbANDuf5loWPqQW7uLPAxqx0xcMbsO3D0=;
 b=b/DlwYC+aqTylKo4OjTa8CEOaZspjlVx181iyRosJOOQFlO4KvZz7kVM7q/vJgFy85tyCv5xGWoJuf43pKE9lndFwl4SQ62cQMraoJG8KWUPUkboUS3EHDDHU3kJ8iy0MXDPjWW62+tAl11zYSc7u7NT6331rGy/DZimRoPLoPw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BY5PR12MB4919.namprd12.prod.outlook.com (2603:10b6:a03:1d6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Fri, 14 Oct
 2022 21:31:48 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6dad:12a0:10d6:5967]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6dad:12a0:10d6:5967%7]) with mapi id 15.20.5723.026; Fri, 14 Oct 2022
 21:31:48 +0000
Message-ID: <fac90493-fb40-d1dd-e40e-d522bf0f33cb@amd.com>
Date:   Fri, 14 Oct 2022 16:31:42 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 12/49] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Content-Language: en-US
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <87a0481526e66ddd5f6192cbb43a50708aee2883.1655761627.git.ashish.kalra@amd.com>
 <Yzh558vy+rJfsBBq@zn.tnic> <f997dd38-a615-e343-44cd-a7aeb9447a1e@amd.com>
In-Reply-To: <f997dd38-a615-e343-44cd-a7aeb9447a1e@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:610:54::12) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|BY5PR12MB4919:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ef3b5d9-1c72-4d6c-9779-08daae2b800e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ntba88K3Z9QL4YyIgmUSxx2alM3gkeMEDxMKdhumawQYEaZ0phycpibvvmaLkCxa2GFgr2mIVtUipo5hrdxfgZJI/2W1dK/M4sicq9rDz+vhqGKb7rN29ROy9mzD6o8zvTumUluZppgRpcIZ5Fz3Fsal2FCvPvF2yEnsyCyXU78mdosjB5+BYLqyQ3iiP0/y4PCSFX8scHPMpKzBOtBM2LdqnfadJI02p6T3fvv9cLb27iweg+mE1YVVvDfq93XXIqstH2Sr1zJp6HSTV6sFCMIzXS0PIZNozUMZzG5P+HD9614SlCGJUb1btQiUpuVLfOZQk2T/xNx2IGFF0fE+RQ4mrFRBpSSiPkPlxUIqdBZd4W1ps7HDOnZSlLqPYQferfQ0Tqqso5US1MJbsQ/3tbn5I4gk571F3QP7sZ/84J+9grBPZ9SkrTBTvYcgjGtLImxP3F1Wb3owOJyqPD8cU+z1wa5iOjRMe8EIoQgvIU9VWSB32BnPrjdOhqKMKjL9cWYIFQg9gGfHOsATUFgfX5ComMT07oxaj/gzovDCf4STCshmEfEZU37AqbEZLjbvlKzPzT59Z4l72Dx3AjlC0MhvuWMGW+H8aHTdK1807HvwS5+p0WcpdtJlmbCTidBFFRzjKzFP4T+ltZUf+ZUonGKLCn1p/KpKHk5M4IMLUe74wfUa8RIWzg7rWdpi6PCyg7rhkfF26b6aZB0qITBgjIj4DPtXogWbbCt16UUiGtJ+EcTByBpG2ThR6TfX+8ye1hOibmf6orPJ3P4KTg8dJZ/IBCZc6q2qtlP1vpTlOQM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(451199015)(7416002)(7406005)(26005)(41300700001)(6666004)(6512007)(8936002)(36756003)(5660300002)(4326008)(6506007)(66946007)(66556008)(8676002)(66476007)(38100700002)(31696002)(86362001)(186003)(2906002)(2616005)(83380400001)(478600001)(6486002)(31686004)(316002)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkNweGZuNVE5Tks0eXgycVNpS3JWZENPaEdSTHphU1dSSjk2SkFwOXBDbUdN?=
 =?utf-8?B?RnVqOWQzUU1nemZDSHRLdUlHTnY0S2xKQ2xzdFhjMTFYaTFkRDg4Ync0YkhZ?=
 =?utf-8?B?aktHaS8wYWpyV3ZhdlRUQ002cmI2VDlLNXZYZ1QrVlNPbjM3eXI3ZEpIc3c1?=
 =?utf-8?B?M3FVdWFXbzBJUUpmWkRnZDdpQUVYLy9tR2VKdXdWNXBpampYenN3WHRvWjRS?=
 =?utf-8?B?clRFZXhENWtvejF4WE9VVzVkeGhzbXZ6R05EWGFvU0hKZ3g1a1VQK3h3bU4y?=
 =?utf-8?B?MEZkV2VXNWduN3liTndjYXhpN2YzRFRCeVlzYm9RR3RWVmE0NG9ZdEdRM3g4?=
 =?utf-8?B?M0toRCsweDJZOUgrOG9URjVDRlk2c2JRVk42NG9XQXlGY3BSeFU1WmlQdFpn?=
 =?utf-8?B?VTg4WmpLN24rSUNNQkc5YXRqcTN0YUhFM2VIZzg3NS9la0lQV3EweE95UmVx?=
 =?utf-8?B?QnFzdGtjZFhMMXZYejNLaE1EMytJVkM0czlwQXNnRzRXOEszcnhzU3NnTWF5?=
 =?utf-8?B?MkUyM2N4TzZwcDRLM0tBRythN2lCTGh0MWJFY0V0cUQ3dUpscE5jaUp5VnEy?=
 =?utf-8?B?VlRkVWJqc2J3R1p3dlh0ZnRNaVZlUXZuR3NuRjlqTTl1eExlYld6NjdVUTFi?=
 =?utf-8?B?VG1raVdTZC9FRXZBbkt4ZS8zSDcrbnowUnFsMXNDbUhiRktDVE1vYU9tRjFU?=
 =?utf-8?B?MUdOcjVWREtzdnY1U2ZFVmZZTjN1Q0VKdEVDY2pCdVUyUEFJb2RjRi9EdHZS?=
 =?utf-8?B?dkplV3U2L2ZJOGt0VFhzQk10VVJhRThkMVprZSt3M1RybUQxL2I3dVNyaFdJ?=
 =?utf-8?B?M3VyMW9kMUV4elk4Rk43SmlTUTg5OWI2aFpnZ1FQRWZUMWw2YXBEZkNWQWhC?=
 =?utf-8?B?a3ZSdEhyYTdjN0ZtT3Ara0pCbUJqMkY5bmk4QmhRb2RONnVhb3lRR1VpVm5q?=
 =?utf-8?B?YUNxRVZtUWdFK3lGMVgxTHE4c05EU1JUaVhCK0thVFZSd21yL2RsaUJzZFdB?=
 =?utf-8?B?aGFIUGpxQUIwVWhvUWJWd3lqVndVN1NSRU1rQ2ZBdXM5T2Z6a0xsdFlTaU5F?=
 =?utf-8?B?V3V4dVVMKzhnMTZrTFVTUERJaFlGOGlyTFo2dVZCVmtYSFJIMHY3YTRodGcz?=
 =?utf-8?B?S0RTYUJnYWVsY0t1NlJMcGhBcTlHTk05aG5IdHYvT3U1cGh0Q3R0TGo1UWUy?=
 =?utf-8?B?clVaSnFXK0MyMnJLa3hhb1dzc3g3RnlBMVB2bXcrdTRBei9HWnFKcm9NSm5i?=
 =?utf-8?B?Z29DSzN5QmNlT0U4K0M3bmlzOGpUV0M4QW1pUGRBYlY5VWdVdHdGaGpTMnla?=
 =?utf-8?B?NklLN0FueENhdVZ1TFpaUHRvLzk5bVlPajFWWnlhWUJvYTN0ZVdZeUx3WUpa?=
 =?utf-8?B?VWxyK3NoSkNReHZJUHpFTEZaYWl4TnBCUkNPQWV4QnBvalRpdERFRElnYkJl?=
 =?utf-8?B?VlR2Wm0ySkE5d1lvWlZ4M29rOThDeVo0VE03YWVOVlRhTlNBaHlhSGliNHJQ?=
 =?utf-8?B?RDZTSDBFT3g0YkowK3hhaHBnRlA2aHNqVlgvcFV0Ty9oemtSWko4eFRHSGYx?=
 =?utf-8?B?eDJTMCtyRzdTOVdFYnhxNWxJTDlDV1lLNmpaMFFLaDJNL0JVckZXdVdxWW4w?=
 =?utf-8?B?UEdZNDBtN3ZpejhFOEwzWFYvNTcyTDZWdnM3eW5kZlR3bUxGNWRVdHMrK1VQ?=
 =?utf-8?B?ejNpNFdLTDlrNXZyRk82N3QrWDhQbnlIK0JXQzYvMlIxclIzaXArWERsVWEv?=
 =?utf-8?B?a1NwdisrWWVKbzJVUEZXVXZ0SUg5K0NLYVZ1TjJQdmVXUTVKUnhEVDJBK0Vh?=
 =?utf-8?B?eURERGQ0bW5UK3F0a214TU10UnBQQlB0Y093MEt0TVFtbk52eitDc01mb1Mw?=
 =?utf-8?B?TnJzaU1VdFlIWS9oZExQc0lwLzlrOW04MVAzcVh6Qkl0Ymk2bmVIT2RFQjQ5?=
 =?utf-8?B?U2NYYTIxc2preXNCRk5kZG9EcWxGNlNGRnlrd3hoVk9LR0RVQkpuYmtqWFRV?=
 =?utf-8?B?eUZCMDl1VTBnTi9vcmFwQmJUb0VRUFFqKzdiV0N3U2ZXNXdpeGN0NysvanhS?=
 =?utf-8?B?anZQWCtHWjViNFBmazVBRkZqZ081cFNmUlZVaHlQeWVKV1hDMjNwdTlxTFRH?=
 =?utf-8?Q?26tx7bb4Sk/Pj4AWJMEtz4XVh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ef3b5d9-1c72-4d6c-9779-08daae2b800e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 21:31:48.2863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SZLxUdV40JTyL5x+Pa1xN+Lt1gyDOYUMO5OnjDd9LfaFaEsckfxhkNNLmGBHtNGb4nUGn7P1Krea/q9gRsOSPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4919
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some more follow up regarding avoiding the second IPI:

>>
>>> +    rc = __sev_do_cmd_locked(SEV_CMD_SNP_INIT, NULL, error);
>>> +    if (rc)
>>> +        return rc;
>>> +
>>> +    /* Prepare for first SNP guest launch after INIT */
>>> +    wbinvd_on_all_cpus();
>>
>> Can you put a wbinvd() in snp_set_hsave_pa() instead and save yourself
>> the second IPI?
>>
>> Or is that order of the commands:
>>
>>     1. clear MSR IPI
>>     2. SNP_INIT
>>     3. WBINVD IPI
>>     4. ...
>>
>> mandatory?
>>
> 
> Yes, we need to do:
> 
> wbinvd_on_all_cpus();
> SNP_DF_FLUSH
> 
> Need to ensure all the caches are clear before launching the first guest 
> and this has to be a combination of WBINVD and SNP_DF_FLUSH command.
> 

I had related discussions with the HW architect:

SNP firmware will fail ACTIVATE if DFFLUSH isn't called, and DFFLUSH 
requires the WBINVD on all cores. By requiring WBIDVD on all cores, 
we're a) requiring the caches to be flushed, and b) forcing the 
hypervisor to exit all guests at least once since SEV/SNP has been 
enabled, since the WBINVDs must be done in host mode.

The order is:
VM_HSAVE_PA IPI
SNP_INIT
WBIVND (IPI)
DF_FLUSH

so that means we can't combine the IPIs.

Also, this is not a performance critical path, so should we really be so 
concerned about it?

Thanks,
Ashish
