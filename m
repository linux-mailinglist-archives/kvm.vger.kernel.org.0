Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4148068F331
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 17:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjBHQco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 11:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbjBHQcl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 11:32:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA423D0AB;
        Wed,  8 Feb 2023 08:32:37 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318G4o3x027790;
        Wed, 8 Feb 2023 16:30:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=CkB5mt7BpEoAyYQpdiSDaKbh5Ki7LtebL5JxPMWhQiw=;
 b=UVPTE6Dr3cO22DZ4lbrlRO3W05u9Y5pnWMNBUqjmdvcU1C7K5YZMfKuuklDxcQoUWPmF
 JSDExT9tNXWuckkPzdp5Gi8GaFIYtHrt8cyCg8VIy6+0y/7m0tcj9pGrtRaRxILStG9n
 kLxPlh6mJUet2VFm3BcuH2Rxh8zymKFsVd5MlY3yxOEN5CRUyHiqs8rNY2+ATXG685Qt
 RI8ugYTr4a+ITdgfZYwhgEbvKmQQ61EWqVATA7843cNuLJQv83eQowQkiddE03Oqor65
 6AiAWHTr2Us7xvSC1TW9CN83sVslXJmFsvpuiy3tAOacyVvkFMNm7I23AzAjUKppxJSA kg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe9ngmat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 16:30:48 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 318GHoEZ028343;
        Wed, 8 Feb 2023 16:30:47 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtdxwea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 16:30:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alCCnAxfsf6YyyOWl64alKnjMBxrOlF4ozBOn0z8eO+ENQEMJ6YuJKcbSxIbeiHVlOgRByqk5O/cHFgWtowUnkw/HxK+2aMiAuP5fOqd94HEdlkNg8FzOvA341yVVynDu3MhwajDJhulXdvpGUrO4nkBKQWwaT+X+YelnXOKt33UmNqi2WR1g2k76tQ9TZgRq6VvP5VO12H2LAz2b5UQPjbPiM30w1pHtMnRM+6NecveHeI6uDuCRHmOWmDSFNGwE5fMbG7CaI/sD8jeBY9knqcn41GPmpvRf119M7BRf5tDIyiVlnj7MXTBlA4m8UfPtgO8F6/uWyr7O8aNFt60Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkB5mt7BpEoAyYQpdiSDaKbh5Ki7LtebL5JxPMWhQiw=;
 b=cuc0qp/Vy25H+7pfIs7pOALQh+tt56z+HGt8jid9PKU39ufnbgtNi+C9kaS+V8zF5HSRNRypoSkNoDD+hef4W39WFg/PvViEVI97QK/CVFmYklO3+wdlFRUxy/VZ5jFbWv1muDiBTxSw17BgwbgP4rIxcqBMvNoUdL8O/uKuAuN5NXCAVFaU3bWvHkJpncPPU3Uw1/hqs8rVKH7Hah8ekbgcJ3+tfOv0Oup006u8G9cP6Bdh41qn0dHriGtVZYa4lLRJsL1FYRBZhf8AOMc41suWyWKmjqBlqmrD7LnBA5FNeI7i6SXfz1Zpb7nTjrEX6tjyX3Ah4BdWd7OVH7EWng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkB5mt7BpEoAyYQpdiSDaKbh5Ki7LtebL5JxPMWhQiw=;
 b=JxsoFnsAEFF05C3cxtWM0lfn+MzLIhuBHn2hl0Ul0997QEnZZr+WmomKLR4Y4MuGXHZD1ZRhDUsAgq1uAa8N0R3+N5grkdp6s6s9+6WF2M5XzHXZyRo4quASf6WB9NgqpUTFI4n8tyBe+2SBDVMieQx0kyGbTVvxZXf7Zp66n/0=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by SN4PR10MB5589.namprd10.prod.outlook.com (2603:10b6:806:204::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.15; Wed, 8 Feb
 2023 16:30:43 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::b6b6:21f5:6588:1856]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::b6b6:21f5:6588:1856%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 16:30:43 +0000
Message-ID: <2f59f974-da7a-4fc5-be44-f3535d986514@oracle.com>
Date:   Wed, 8 Feb 2023 16:30:16 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH RFC v7 16/64] x86/sev: Add helper functions for RMPUPDATE
 and PSMASH instruction
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com, Brijesh Singh <brijesh.singh@amd.com>,
        Liam Merwick <liam.merwick@oracle.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-17-michael.roth@amd.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20221214194056.161492-17-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::11) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|SN4PR10MB5589:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e5c9ada-bb3b-4227-5fd1-08db09f1d2d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ckQMy4EYVkLtu6qpwJnBFVHIM/J9++v1rT0PtByqLj41jPnQk3JkI7QAiJ2TGcbLjL1stC5HsTfBBIRTzZgH6ad+jGtHajooBihJ6uvsyng2855oifXVTft+z4K9jZ6fsAvgHxj/cYUTzZSSmMQGwYwJYzol7fkQkgsNzG4GAiC2C9Zk0yNbo6TA8TTH7qY86Le+3KovpY/IaYKd+D7CKPbcl8/hdu9/ZENmL26phaWBsw4nxvu++AgM5ynBzhfAVL+UZINzZ7HNI5TEhRmKMMjz3N3NEatGGuAa+pabP/AD9lOx19hh+WTh4XjJxZGgx49LzgFMAl9q8mItwSpON/jcgDxkRJkgoEVfVCnlkwG5CvHKdh6uHLucR3qhKXe9uzDbIrmjzchsWSKUBSIEf9SCSdwxCih05yF815NPHk8n8odCLuh8ihS+o1d8sl62EetowDBdf/IhyTqchzgtWXlUUhGghSMGxVEoce8m7D/ireNIKkdt57OVYOpVkRYLKe7XvBe3d1ZsDWuhB1WVMM3IYmmHO+2pVSWk0XBP6OfjgP9E4ITHoUxGDB/uNBvVG8jeQEWuTotk2Vt4C6zhvG4K2qC/vuTPuhQAetgU3OcnIlIPICfgBuu+awXAXxi7iA+DdQlpWgmh2mb0BowUY69Ej7Ecbf2r8VqtZEz4HPZTHFCrgo+o5wMMyScVxj73jAkOuJaX74RnY92Mqo4tYplZb69UCK5+2xWmJl7UJYY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199018)(7406005)(54906003)(86362001)(2616005)(31696002)(316002)(7416002)(5660300002)(6512007)(186003)(26005)(53546011)(36756003)(478600001)(44832011)(6506007)(6486002)(107886003)(6666004)(31686004)(2906002)(38100700002)(41300700001)(66946007)(66556008)(66476007)(8676002)(4326008)(83380400001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFRCcW5tUVlhaGNUUmMwZjgxZVI4Nk5aUkJoT0cyV2JGTDB6QVJKU3dtK3FD?=
 =?utf-8?B?ZjNYUGJhQjhNb2RpZG9FRXV4bSs2dmUwY2tjWFQrRUN5ck8xTys1elBTZmVY?=
 =?utf-8?B?a1p6cVZvMHhKZk5pL1BwUHZ0UGpWSzdUMWFPM2swcll5L1lmWmQvUk0yc3A2?=
 =?utf-8?B?RFpNSTd1VjJmTVFjbXpLVWI0NkN2LytrYW8xQ21haXhicWhjcTAxNlZ1OVZC?=
 =?utf-8?B?ZVFUOVRUU0U3c2x2Q0F0OXRlaFEzVmtpM1ZjV1JQcmtQRUVROEh3VUltNElL?=
 =?utf-8?B?NUc3cVRnV1pTWW9BOTlraE4xU2lna0xkV1N4aS95Y1ViSFl4Q3JZSldYSlVk?=
 =?utf-8?B?NzVoMndnQ1VZdWFQQzlFbHhtZ2xSUDFuSDFCOEVDNVY4T3BlVjVpWjF5YkJn?=
 =?utf-8?B?WVRrTXlYcHE1bjc5Z2VreU92RE9iMzZTYmw0bXBJa21Zd3oxcGZvUVZ6Y0dE?=
 =?utf-8?B?R01DSFFHa3RLMklsR2UzZG5OVVY3SnozaWVGN1A2UWRhZ3JFdHEwOC9INEZp?=
 =?utf-8?B?eTFjMyt2MGJFS2JPZHFGaDhSMEl2MytiTkpvRVlzMk4zM3A2S1hLYWdwUTBw?=
 =?utf-8?B?SzlETkZzSjdWelFSY2M0aW9XaW9RWkZvNlZFUmxLc3l6WGJSbnA1UjhaZEV2?=
 =?utf-8?B?Rld3Slorb1JQSXZRQWRGS0dvRmJiYkZnUDkrT3FlVkxpOGNxc3YwVVd3d1Iy?=
 =?utf-8?B?NGNaU0NUaktlVHExamxoSUdNQTJveXdiYlVnZFU3ME1Mc21RVjZzaVJXdy9N?=
 =?utf-8?B?R0hxUm90blVZUXpzb2krcER1ZW54cVBVSjl6cGRCODdkdEovQ0dRZVQ0NXZu?=
 =?utf-8?B?T2pDOFlvdStoWDJrdk1TKzhORW1Bd1hQRE9GQUQxN2lWdW1FKysza1JCRHJK?=
 =?utf-8?B?c05EejkwZGxXVWFGTGpCeEpzd216aHllaENSL2N1WHJnTFE3N2pyY3VxVEhB?=
 =?utf-8?B?ZmhPRGVyTkJ6U3RLaW80SkJzWXAzaEthZkp1TVBoVGUzTVFrWnRrYzlveHBq?=
 =?utf-8?B?akNLMkN2MEgwSWtsc25qZlU0V1lCY3JjUkN5OHhZYldJMFE3YVNpaWc2b05l?=
 =?utf-8?B?S2VZQzIxQmp4VmVHVm80ZS93dzF3dk1DYXNSZWpVMnZSZ0UyTmdtdkhRNjQz?=
 =?utf-8?B?VWgzRnRvczFNUHNhRFlTSWkwZmVIYzZ6dit0aHN6UVdvUkhvczBlS1lkYndu?=
 =?utf-8?B?ektldi82V25SUEF5VCt5T3pOd011ZEt2VXZwbUxFN1ZvK29PMUZBSDh3MFNw?=
 =?utf-8?B?bEFBeUhhd20vVEtFT05JVFpod283YlRkT3RwRWlXeDJwOTFGaG5RYVZoU24x?=
 =?utf-8?B?R0x1aEc5WTNySWxzaXM4cXkwMTQxVXFVb09uWXhuSXFWMC9WSlRPcDdaRnda?=
 =?utf-8?B?Vi9OdFRtL3RSVUphQjhOVERLK2wxQkR6SVdUTTZDSURtRks1T2diTGdOb2Ux?=
 =?utf-8?B?WC9NS3I1RFRLSTFYVXBuOU9qNGRBWjIyL2dOUkkyYlo2VFJ6L2NQYjlKb0E2?=
 =?utf-8?B?NmJrMERQb0JCdjNKQ2w4S1BzQ3hkYmVDd3h3K010MGw0N0xaTzZpMUhKcUlz?=
 =?utf-8?B?bDZHbFBiaXhLYzJDcC9ySUpRMFMzTzhlWVNtRng1alZJN3Z1N1hjTnppd3JF?=
 =?utf-8?B?OVZNalQydENsMTFFMlE1MW9ZbEIxRVlleFhVa3Y2dWgvRVkrTzJOSytEMG1x?=
 =?utf-8?B?dWRmTm5TL2RZTC82SkFpcjZuVUlXaWZ0N3Q5emF0WnpEVGZGWTJ4d2cwbWZ0?=
 =?utf-8?B?MThjbGtNZFZ1eXB2YXExd29vWjJUbm5sdjFjSnBKc3VGRXJMdWpoNXljRTlC?=
 =?utf-8?B?VDFIRWRHZVJJZkpMVVNuYUJYdThWbHJONW5XTWxKM3ZXTVJ4dU1wdDVvMUF4?=
 =?utf-8?B?eEFsS041VUkrYWx0dEwzWDBlakdrZkJQZ0ZSK2F0VEVlUk91RG0xZHpVaUpV?=
 =?utf-8?B?M0tlL2kxZWo0TzdTZUsxb0lxUDlYMFJNQlpsN3NybURNNmdNKzhSbFVYUkc2?=
 =?utf-8?B?THhxaUNDRmV3ckFUREY2WUdMVWhTejNDalV6MzBEOEtNRXc0VTF6cjRVNzhj?=
 =?utf-8?B?UEx3L05lZ1EyVzlDbXBxb0dqV3pGZkZZT1dwMFpmNkl5bmI4RGo5SUM3bUw5?=
 =?utf-8?B?cHFTOXJtcE5JQkVmNExjQmg4TFZyMjU5bkRBUk1lcHU5WGpjaXJxRzBMelda?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?OWdhTy9JdE44Qms0VzRDNEJmcHFHcUFYK3M1d2Rpbm15QmZ0cTNZUlhwTDR6?=
 =?utf-8?B?OGIreko4R1k1L1F1eEFMajVzcmtRSmVCc29YNlVtNUIrbHNCN0lJUEFMWVA3?=
 =?utf-8?B?QjB1cVRVUlFQcnFsem5Za2tyS0pWenZxZ3lmWEkrR3I5V1ZIVEdydGxUYlJL?=
 =?utf-8?B?SldlMHdxRXV3cVNGaklGYjhMQXhENm1RVS9kY0JkZTduRzZZUDJJTWNmZ1Nz?=
 =?utf-8?B?QUpsNmxsUFExNEZGOWJLMW42VUhPYTNzaWlnQkNCNG1nazlPNU5aN1RYc1Zx?=
 =?utf-8?B?d3lBVDY4ZXhGVkF0MUN0blVVR3RRSk5lZS9EcTZ5clV4TzlYZ2ppV1BOQldJ?=
 =?utf-8?B?cmVRRDg3WGYyWGpydjJGSnpFTjBIdkQ4ZEMyQzlueGMvRm1kYnRZL2ZiVUZh?=
 =?utf-8?B?UjlheStLSDdpOHUxR2RZVFI5V1pYTFVVK3hudkIrZHdHSW1oY3hIV2FTZi9u?=
 =?utf-8?B?TWw5QklyeVdxMTJNaFpMTWdHY2h2VXpYa3F2TTlmYjd6c0J2U29sQjY1M2hp?=
 =?utf-8?B?QTl3aEJEaEM1Y1lJMEdGUG5GMXpwZkdkaWN0N0JyZHZheWRnRThDMHFNMmwy?=
 =?utf-8?B?K3doM01YY1QxanFHU0YvK1F0YkNRQmpPd3d6RkdSME53NFVURGlpYnJySnk3?=
 =?utf-8?B?dWNZbTJiOFNqZEhaaU5WRE84ZnVTbWJVTFlBbkhMZVNsZUNmeThTY21ZK2cx?=
 =?utf-8?B?Y09PSHA4eFhNWE9lMFh1WWx4RjZVcGFQczFFKzZDRi9JUXo0TVF1RTFzVDc3?=
 =?utf-8?B?MHVrOXhIdnVvWlljZTJWRGZqVWk2OGhIdzlmZjZVUUUzMUt1azVvdTlqVVZk?=
 =?utf-8?B?TGMwaUJkVFVjS3hEeWNFU1RCYXE0akk2cUdnOFFWUEVZUXNXaUNlUzJSN01T?=
 =?utf-8?B?NjdsWWc1MkUrQlBleFNUaGlqNTNOem5yTk1qb2hSUTdEV1BpZVV6RFF5MGhJ?=
 =?utf-8?B?aldtRzlUZXVJd2Q4V1ZiRzdvdWJTcjFXWUFvNk1USDkrYms2YjdsODJGMjAr?=
 =?utf-8?B?Y0VhbHM1WjVDc05WMGhMUXZVMG5PVHN2VVZMNE51bjVZOUdmNXBpTTdoWmVr?=
 =?utf-8?B?bys2QTF5T201b0dCdUJzTHljMHRGV0krV1lkSGM1aHMzTjFlSVhzT0FkMjNP?=
 =?utf-8?B?ZVd2YzVSa0dTYzdMY1p3MkRXV0tCdUZnbE1pcGV1VkxKWkszR1ZhK3BKSHlT?=
 =?utf-8?B?ZGlOVEFKTklvRWdtVXp3ZmtqUExRSWNKLzBoR1ZVS1I2VGthREU4ekhPenB6?=
 =?utf-8?B?alBWS1pMcHlvZ3FWelZZQXF1ZG54K1pDK0paRnR5cmJEMDF6NldqYXNmY0l0?=
 =?utf-8?B?dWpxVDdKR05NS21zVWw1ODlIUjVjRUNrQzNodUdkRUsxTC9oeHBzVmVWZW1E?=
 =?utf-8?B?aVNTdzdpL2ZjYnAyWjY4S010YWExaFlVOVl0a0RxTjNtL2ZaRThvVUlyYk9x?=
 =?utf-8?B?U3hoeTdOZkFUWHhZM3drdURkNFR2RTZNRFNLQnM4VXUyemFpN2ozazVCamR1?=
 =?utf-8?B?a0s4ZmZmTmY5bVl5ZEFRMDRTZCtjNFFPYVB6Y1lvaDdhMDEwZ29oNDNQUTND?=
 =?utf-8?B?TlBTZnhJUi9ybnVaUXlVeHpYOElySzFRSzVRVi9rUEhiZmR5MmdFNE11NUVF?=
 =?utf-8?B?NjNZOW9WQ0VoWTFPMXh4RmJBVEQxTEtsSXNwYkZmNGMySVQ5ZlpKN2ZJdnFO?=
 =?utf-8?B?QjNObzlPVXZrL2Ztc21JVCtETjJ4MmVHNXpnYXM3YUoxV3liUW82OHQ1bjNo?=
 =?utf-8?B?UUhjcFJBclRockdxandqVThTamdKRFN2N2N0aE5ZdDE0WVZubkdqZXRyKy9J?=
 =?utf-8?B?bnROb3o1anZUWmN6QW5oQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e5c9ada-bb3b-4227-5fd1-08db09f1d2d3
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 16:30:43.6111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +IC+Ep1TjP+6bgXW+skvSXKf2T/1dW4WQMmSlidzJ9cw1G/XRCwuSoZ31KlRihwrF2FHp54HP50519LU7KambA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5589
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_08,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302080145
X-Proofpoint-ORIG-GUID: UmpBGBjf0UEiYCSCTjQ826vSPaBD-Dmy
X-Proofpoint-GUID: UmpBGBjf0UEiYCSCTjQ826vSPaBD-Dmy
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/12/2022 19:40, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The RMPUPDATE instruction writes a new RMP entry in the RMP Table. The
> hypervisor will use the instruction to add pages to the RMP table. See
> APM3 for details on the instruction operations.
> 
> The PSMASH instruction expands a 2MB RMP entry into a corresponding set
> of contiguous 4KB-Page RMP entries. The hypervisor will use this
> instruction to adjust the RMP entry without invalidating the previous
> RMP entry.
> 
> Add the following external interface API functions:
> 
> int psmash(u64 pfn);
> psmash is used to smash a 2MB aligned page into 4K
> pages while preserving the Validated bit in the RMP.
> 
> int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
> Used to assign a page to guest using the RMPUPDATE instruction.
> 
> int rmp_make_shared(u64 pfn, enum pg_level level);
> Used to transition a page to hypervisor/shared state using the RMPUPDATE instruction.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> [mdr: add RMPUPDATE retry logic for transient FAIL_OVERLAP errors]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/include/asm/sev.h | 24 ++++++++++
>   arch/x86/kernel/sev.c      | 95 ++++++++++++++++++++++++++++++++++++++
>   2 files changed, 119 insertions(+)
> 

...

> +
> +static int rmpupdate(u64 pfn, struct rmp_state *val)
> +{
> +	unsigned long paddr = pfn << PAGE_SHIFT;
> +	int retries = 0;
> +	int ret;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return -ENXIO;
> +
> +retry:
> +	/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
> +	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
> +		     : "=a"(ret)
> +		     : "a"(paddr), "c"((unsigned long)val)
> +		     : "memory", "cc");
> +
> +	if (ret) {
> +		if (!retries) {
> +			pr_err("RMPUPDATE failed, ret: %d, pfn: %llx, npages: %d, level: %d, retrying (max: %d)...\n",
> +			       ret, pfn, npages, level, 2 * num_present_cpus());

This patch isn't bisectable - 'npages' isn't defined in this patch - 
it's defined later in Patch18

otherwise LGTM

Regards,
Liam


> +			dump_stack();
> +		}
> +		retries++;
> +		if (retries < 2 * num_present_cpus())
> +			goto retry;
> +	} else if (retries > 0) {
> +		pr_err("RMPUPDATE for pfn %llx succeeded after %d retries\n", pfn, retries);
> +	}
> +
> +	return ret;
> +}

