Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9985A4BE205
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343757AbiBUKm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 05:42:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355276AbiBUKkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 05:40:12 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93761027;
        Mon, 21 Feb 2022 02:02:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evBQi/e4SgIDMf7Sap2/1PGseafIXtgjsnbfAIfddoEqZtHqcVJTp7ZxAsANqDwIki8zXhmcL0hGSWiRUw7euE7KYhF85bXWPZx+Ty3EzQ1qdKzM5ehgBDLDGc2ykkrImBCB2PkfPEHJEzgNOLo80e4GrcivdxNsliHOaQ71jloeVvMptRZx4ApTbLLeRP8CJ9NBBt9Y+unh0gID2g5oPbl+jeWBCmAlOLVXrSg7qZX/mQIbqZZz/SOgTUkkXuaAVF2fV57yykwI5fnrOe7woQix9zcnSnrnpms8lDpK5JjhO/18nyCKPssnnnlqc9i5TOxmmLLO+LakftR3ixo78Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8fDrWoLKcLYbCJkPPLWWhj0PpvXc0NNRdd51yUypoU=;
 b=oQeRv2eoTp55QLFHZMRUcp+CuBrUOw5zgRBvrOiKDGBKnh8KZ8Q4XUevk5Cwx85eobDvnaR/VZjnPK2qk3A9rVcm8CCmJPIVTyITVd11ikF9fNluW4YhpIm0sc3bo6uYTkdF3sLPaf0qeXEjhtOG4MAPKb92Yfwja1sht9rRgMjdy0qA30qlHdzANsPGtr49k9LnNZ/avOrQmEWWeHmg4Pl75sKC453YOswYp5pEx/hPKpMZPJW2Mm8ANyH5CRU8NeDYfH0Rd0fkbfp509DXhBteDlT1k8WNxvj4AhxqWJIFpNYQpFOm8Xc3fVlv+II+lt9zSzXuHR/UVFv1/RJ1FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8fDrWoLKcLYbCJkPPLWWhj0PpvXc0NNRdd51yUypoU=;
 b=XYvZvTdd931oFAowclmkZc8ipa54VuD8TVZyT90bb6cacxJLKPyF+918tssveCxwthJoo6IToY/yliGIFQ6+PAJzHbOhjFs2LMHIAhD1qHwPWxudFe6AEO66DlSiKDbRmKXpzHE2HLau/NU17nWTdaS1ejj3InZiemE7QXlAwUI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3053.namprd12.prod.outlook.com (2603:10b6:208:c7::24)
 by BN9PR12MB5196.namprd12.prod.outlook.com (2603:10b6:408:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Mon, 21 Feb
 2022 10:02:09 +0000
Received: from MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b]) by MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 10:02:09 +0000
Message-ID: <80fce7df-d387-773d-ad7d-3540c2d411d1@amd.com>
Date:   Mon, 21 Feb 2022 15:31:49 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 3/3] KVM: x86/pmu: Segregate Intel and AMD specific logic
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     seanjc@google.com, jmattson@google.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        alexander.shishkin@linux.intel.com, eranian@google.com,
        daviddunn@google.com, ak@linux.intel.com,
        kan.liang@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kim.phillips@amd.com,
        santosh.shukla@amd.com,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>, Ravi Bangoria <ravi.bangoria@amd.com>
References: <20220221073140.10618-1-ravi.bangoria@amd.com>
 <20220221073140.10618-4-ravi.bangoria@amd.com>
 <1e0fc70a-1135-1845-b534-79f409e0c29d@gmail.com>
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <1e0fc70a-1135-1845-b534-79f409e0c29d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0080.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9a::22) To MN2PR12MB3053.namprd12.prod.outlook.com
 (2603:10b6:208:c7::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 263ddc83-cb52-421c-d54d-08d9f5213927
X-MS-TrafficTypeDiagnostic: BN9PR12MB5196:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5196E2AB958B3E60D31DB2F8E03A9@BN9PR12MB5196.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JrEvX2msA/iN2yJwOmM1GD/NENm6tySyM0h2RqKaX0wumCBtMWFys9BHl4/oQMf/vX+N/Z5v0eITXzfREy4c0F/HJsf3AvW1dDitVKoHYzstelv/kxgtmCegI/jxlfr8acemqlSytt3yFPuKKuEINyzywrbFKBoSaQnhX4YpmvjuPJBoXqgCqKjjDlpCejX227oLgmaxdpoeq8qMIAVlma2ldNHu13usDr4hdBz72IO+dScjfaozGMo++XFlwoBpZyV1pw+8r3hsjZFNRXSFXdI8rxtc28ov5TryxaPpLF3auH4VeGntxO1OtV0wIjj+nA0aTOFF8SHeKyEa9JmcXeI7o8OzBHe9CuJUSyVWwcIakE7BcULCi4MJC/lgaFFLi0+6kjbqT3+1XIOl5gHmXxfETjjbAF4tK23w8ecqYdYmm38xaUEGJHj2VYaNBIWefRykFjSPjr0WvKuyWs9y9tS6QeNyhl2c+M7PEkIWPh1tIwhn1oA3iurBsBjTD7CIT4Vy5mALtVd0mctotMLWaRgoLxo0c/Gid4MZAiTwiMEbUlx0Z1zezrwbgQGfb4tPF5cGsBARlKB+aJSCrbudwpZ87sZHzfGRSdHHZGr+w4f8SGMj9wSFo48xeyB9MynDyDsGq5cRfGosewmycN3EsTHt0ZUxFvKUA0SDO5jcd0PbVYp+ind6X6DI8uCR+aMADmmVgOWS+E4fOKlBrW2VYSjNYOnU8PDCZSLje+HDSH8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3053.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(54906003)(6916009)(316002)(508600001)(6666004)(6506007)(53546011)(31686004)(36756003)(44832011)(66556008)(4744005)(38100700002)(8676002)(4326008)(66476007)(6486002)(31696002)(26005)(186003)(2616005)(8936002)(86362001)(7416002)(5660300002)(66946007)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGUvZlZ5aW56M3VvenpDWDF6bFI5dmVCT2tNQ3lEOWlOUWh1ZlRBYTVmOXZq?=
 =?utf-8?B?TTlTYThyNUZWQzlmcEx0bGp3V29ycjh4Wk54S3NzcG9FRThkQUVWbDhSdVFH?=
 =?utf-8?B?d0Ntb2ZUVFFaUmNYSHFXdG8vZW44OE9VYm9mdVQ4THNSM0JuVFpmcitwMmJw?=
 =?utf-8?B?OXYvOGlJQzRSRHdiWWVOVEZubWc2WW9TOGlnTXFJcHZxeUVFbUttMmtkOWhM?=
 =?utf-8?B?c1JTaU5sV003NUZ3dzJtOE9pck52VDQxK2hHNkFySk5mR0FNNjZnZXV3NkVy?=
 =?utf-8?B?YTZnL2l2VEQ5MUtZUWMwNjh2QjUrTEhEckVWeFdHdXNwZnlWdzlVOU44Y2xT?=
 =?utf-8?B?VjZpTmVvU0pLT1JoY2pWVFZLYzhGcjBjbUVwSTdFRTEvbThpNFZEenhpeGdQ?=
 =?utf-8?B?SWROZ21yNjE4U0dRVFByQjFyRjcyazFTY29IeGRGcmlqbVFPYXdvWlIwejJp?=
 =?utf-8?B?TUZNZlRvRFVqNncyVGhyRlZzTmNIZmJ5Nlg4Z1J5YStzcWlRTWZpb09qd3R3?=
 =?utf-8?B?K2xQdllhUXFCeG1SNG5YVzZOeG5nN3ZTekZEMyt3eVFvU001YW5KTHZEOFFL?=
 =?utf-8?B?UWJTRERGenlYaVZsWVYvcmZKSmxlZVJ3WTdveDJpOFVVdnZLRUJaYUhwaVNJ?=
 =?utf-8?B?YjZUL09jeHFPQVdvUE1CeVlFRHVKT0NKcEJZVkdDTmQrbkYvY2o2aEppNTNW?=
 =?utf-8?B?YTh6R2N1MEZ4NitGRWt0aHhjd2lhczB0WU9OaHNGZFVyeGx5b0JELzJsVzB5?=
 =?utf-8?B?Z1ZmL2xiQ2FZenU0Qmx4dlJZM04zd0RXUmUrYUVtTjRSanc3NjZsQm9mMCs0?=
 =?utf-8?B?REh3M0oxUnZOVS9UazlRbnlVUW85NXBVNCsxSUdhRlM0aUNHL0E4UjdxSldD?=
 =?utf-8?B?NElhM3JMZDJ1dnArTm5VblZQS1dDNTRmR0s5NDF1UzhlME84NWNXMjhnKzBN?=
 =?utf-8?B?aFRzWEg3RjREbnorTHlNMFpmOGpqY0hTU3VpdWZuNWdpN3ZjVUdmbWxlczdh?=
 =?utf-8?B?aUp5RDhER3UxMU5qWlJIYUppdUUrRzM2VVczQkpZZ0hxVFZSQlZyK2pmRHkr?=
 =?utf-8?B?ekRwTkhIVXZZUXVOTkJGQWp4dGJTdnQ1WVd0dXU3ejRWYlJESzJQaDhxWkZ0?=
 =?utf-8?B?SFMzUGNGbTZBRUVlWUdDcGVOY0FrY2kxc091L3VVazk2SkhPUndrUytMcWJh?=
 =?utf-8?B?Q3FwU2tCZU5HY044aDlIZzVOKzJJUjluUDA2M0RmNm1yeFFzOVN3aHRsZW5U?=
 =?utf-8?B?UHlvSnd0SFhsTllPblpzekllSk8wVHRBd00rRGJnaXVVbCswc1JyN0hpZU56?=
 =?utf-8?B?cHYva2E2cUdFbFpnMFRDWjQyRDNKbDV4YnNYSmV2aTdvb2lDNFovc0hxWWZp?=
 =?utf-8?B?WHhvUkRTMWRGeUZtQ1VUYTdPdW5tTjE0bW1JYnF0NXFIUjAxTnJ0eUoxYmZZ?=
 =?utf-8?B?T050ZjQ1TGE5VS8wWDJzMHlHa0xJWFB0TDMzZXpnRFNCRHVNaTNKYlVxUmpX?=
 =?utf-8?B?VWZ3S3ZNMmdBbjBYMmM2eitWVzB5V1hSRlkxbGJ1cm9QOHVqUFdIelZCU1FC?=
 =?utf-8?B?U1RlOXVRSWV0c2M1eEZoRllSbTB4NmRZNnF4eERhNEIydndxNnlNVVkrTU93?=
 =?utf-8?B?YVAyZG1iTm5sUnFKT21CNGQ0anRIRGtrdy9zczBSMVZ6ZDBoL0Nsam5VMVJ1?=
 =?utf-8?B?TTZhb25RRlEzcmEzRVFCTlB2clJjN1NteHQ3aWRDakRLWG9HRVM5L3BLalE3?=
 =?utf-8?B?NHJKTFpsVHlJSG1rS25yakh5UFdxdmVnM3FZdXdkNUhjdEdNbkVIbE1HWFZM?=
 =?utf-8?B?SmwvK1gvZS9CV3Q5azVKYmtwa2JrS3l3YWhDUm91MWNwaFhvazN5SFp0cEZ2?=
 =?utf-8?B?MHp5ckIxOVZxTUJxbmZHR3pNSGd3OFVFTFBERGlnRWEvcEswQ3A4TlU4S3NR?=
 =?utf-8?B?QlhjcUlwU3hUTSt2T3RQeFdVb0Z6ODJOdXlibDVqbVZ0Yncwbmh3T2NEZ21G?=
 =?utf-8?B?TFlQRjFHdWJMMURCZG93UXhwTXdNYmF6aFB5UVpmN2hMYnQvQWV4VC90Z0J1?=
 =?utf-8?B?UjFEalJyS1djR21MekJrcG50T2pVNXlUdysrS2VhNGtQdGN3MHZkNkoyU3dO?=
 =?utf-8?B?QlFRZ24rUDJreGRlR1I1SEhRaGZYRHVudzVNdGtwMnB5TnpZQmI2TW10K2p6?=
 =?utf-8?Q?IzyZbcVtQRfX29eXj2aIjs0=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 263ddc83-cb52-421c-d54d-08d9f5213927
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3053.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 10:02:09.5492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6jBGEljQY1/b7VZT847plKicw8ah9PtL5f+0dpurSEkrsm+UFWWR+obTell/AATzyVmNL6WaHVPR0+O8+bo3xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5196
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21-Feb-22 1:27 PM, Like Xu wrote:
> On 21/2/2022 3:31 pm, Ravi Bangoria wrote:
>>   void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
>>   {
>>       struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
>> +    bool is_intel = !strncmp(kvm_x86_ops.name, "kvm_intel", 9);
> 
> How about using guest_cpuid_is_intel(vcpu)

Yeah, that's better then strncmp().

> directly in the reprogram_gp_counter() ?

We need this flag in reprogram_fixed_counter() as well.

- Ravi
