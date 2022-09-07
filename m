Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D33F5B0AAF
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 18:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiIGQzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 12:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiIGQzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 12:55:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6EB14011;
        Wed,  7 Sep 2022 09:55:04 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287Emki6008373;
        Wed, 7 Sep 2022 16:54:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=6lK4uC/4f8QkZ1hm99iF3JbVNVmFWQS9bGSVfg8QPd0=;
 b=NekGRXojaN5NgbKAuUl/Hm0Br42BTlu0ZKqMt631lHyxVv6BdkqvCy/zphuXrfyIbm22
 07DzRTvFzIC7uPbKlqLXI4p8A8REEGjmzrkSiuhozu7vZWyH3kRMJVydmEdwiWBsz4NK
 5LY+yAwjHMmJ5BrHwcaMAFz/S4K60C7mbjGomKzKfqqXBZhnMqisBjIYXVuok9LC9ddI
 4qaYRqXkRTSGDbJ2bWnYsis8LZZwhgWurl67cIBeUdjgr4Xmpb847xWdBlvTDiULQ/tk
 +yFFDkPeVdgr44JJ00txpM/nR1JNhgDviiALD3oVGg0YwSy3VgLDERtIwr674hm3X/Xx PA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbwq2hh8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Sep 2022 16:54:30 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 287GEiuX035060;
        Wed, 7 Sep 2022 16:54:29 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jbwc4bg3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Sep 2022 16:54:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DF0lnEnLl3S60ZsI0iLcftFABwi7j81jz5+zfQ19HzWA0X1Mk/p7+31bgqsEMxb2YxpF/WgGh8z4TLUAu+/B4BeC3fhZanWZO2SMagiOsMxRAJcAUJpNQ7cQL+CIk36EGUO2qLj2aDFBPhKJ2Zi9KFVf2rZ7pydcnoAqMPy4Og8YbwubTMq/0bKRqpj7rVRuwBGbecYumTrcIJeGg7HuTRmvqlHHzO53m0Jwrjqo0UnqUn7BSsqhrFhFH58gx3QX6i/MBb4VfTwNoLAIy2rPMGjYthUhXxs9dtb9TWegRoZy9nSBaXRzr8tetMToeesxGLw2cOpCF7enbu2S93JEEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lK4uC/4f8QkZ1hm99iF3JbVNVmFWQS9bGSVfg8QPd0=;
 b=RgOSb4s1RrM0ZJ/pNtM83MghvtN497KT4QEzxBJb5PDOpb6K/IVzNV4w2+eXbWSC3fjjn4kQH2klEfAHT3PXV3CrXm2sP3IePaJn6qd7E4TcZ/fjTvo+R7UTUtdUdlUVt81Wfly06HI5kXTWVbNpxDw7cP7r1PBLby3duQWCP9WfJX3WRcyZJpnY2PI3LQbEe6hIWIDIJsPjsrfJ8YFjFc6q2XOHIz/SBY8YWIQ8mny0IPiwFL8bREvNIWYqJQkE2rTRnbP0xrXZxregQ0bTKTXt5ibD60yeKqsD7bpXKu1KlkDlE46LiBaG20WLlRORhQGSUHeMNKnSpG5qpfkJXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6lK4uC/4f8QkZ1hm99iF3JbVNVmFWQS9bGSVfg8QPd0=;
 b=q14DsUj0ZkeyIv6KFr7LdlJvqALDGo8mZAtpA+ABKIAePsVLc2BGEZZ1Wy8BZZsl7XfizXTlas3vqG3OM4CMTYvQ4u4MGTofYxsDdvXEF4a+dgNsTytYWxr9rk35APlGBoq/uNV86pfK9e/KjHrG/EyYPQFtju2K124ggUU+eec=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by DM6PR10MB4315.namprd10.prod.outlook.com (2603:10b6:5:219::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Wed, 7 Sep
 2022 16:54:27 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::9034:820:1811:4ca0]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::9034:820:1811:4ca0%5]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 16:54:27 +0000
Message-ID: <fdfb143a-45c4-aaff-aa95-d20c076ff555@oracle.com>
Date:   Wed, 7 Sep 2022 17:54:13 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.1
Subject: Re: [PATCH] selftests: kvm: Fix a compile error in
 selftests/kvm/rseq_test.c
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220802071240.84626-1-cloudliang@tencent.com>
 <YxjAZOGF9uSE2+AT@google.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <YxjAZOGF9uSE2+AT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::10)
 To BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|DM6PR10MB4315:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c791f00-5166-4df9-cede-08da90f1a021
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g/mMh7WN3P6Me5PIdXn4mFkHb7tMzpPhhdK9poNVwzXLjcr8bpCdJ+iOGvKucTXjUrrFayaXLpdtOqh2WtmD+O3pg0DASDRI1inwXbaECqQ8aa+ckERpWnRdPu5r6mgzduIh6l10LunqUYB3Wfk3LUu8M3AMZ1EJ4OYnLpqFxJDaN7Vq/KEoweZWGXq7C/6UfJi/swEMlxk+tCICe6pmmebLSpIymQZgP6ctCcRU/rMZzjNjfmMPVSaDEUBICB1+1jFufRWoq79IIeJFSCbNJCmbNQq8B7+2VT62S0HX2K0gJ9ZZlxzJYcOUBKSy2mItPIx0eAFfe9BFTI+AAIhgQr3cmPo3KfJwZXTAPhu27xw3ef+5GkeNmNhrsXQ6hq/rKDM9zPpk+tAo5c51G5NkLsdulHwrzmyepc3/rpj/lOLQXY9eURJoW3Js828b9lbB0uZIqcKM8XLjvMIErV2iodCDY6TX6IvXNwOhVEPq8+a8vurnXgLTfsDkeI+WiferQbD77HRL7HNvTe35KvP6VgxMx1bUqIsdOM6jJIigigEpVibZ1fntt/YZOy7lplzxj65rEFdYXHLCmni77Arv5ZtjwPtUCkjpmewqkeAhu1yQIdw8ke9Blgu7zCPcBq8ayiv7hXY/iO5qpdiwk3ecUqYetq8TN0QKByvV4zlB3ZOODqjJRMzHGcAWIJObpDtsRz4vh/UuNZmCmOt7y+bufO+JH65Umjc5xHaKFW3I4IS0fEqBgQcwy5pbG5AHhfR4/FDYZHzfi9yOPsmS6r2V3SkTryOjph8GvupBmVk9G2Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(376002)(136003)(396003)(366004)(54906003)(26005)(110136005)(316002)(6666004)(2616005)(41300700001)(6512007)(86362001)(478600001)(6506007)(31696002)(6486002)(2906002)(53546011)(38100700002)(31686004)(44832011)(36756003)(83380400001)(186003)(8676002)(66556008)(4326008)(66476007)(8936002)(5660300002)(7416002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUxyanhJZ0ZiWG11QjZJdEJhNk1BUzhoRFVSeEthRnR5UXdYZkp2eTEwL3ZZ?=
 =?utf-8?B?QjdReGRhT2tSNkdZWWxlR1FkQXZrQ1FNaC9FbDJuMkxVbXpQbnAvVTgzVVlw?=
 =?utf-8?B?bzBXaHNiWm9UQ1MybzJEWWZxOS9aVGtqRmhUbmkvZ0FUdUZCT2xORkY1Mzlo?=
 =?utf-8?B?SldyaVp3MzhXaVFQRTRWR3VPRklwNmp4UUhsK1pwcnV1a0lGR1ByQ1BTK0F1?=
 =?utf-8?B?Mm1IK0lIVytXUUpvZUNOTGRrczZ2OWxCS0dBK0YzZHE3MkNFcXkycFI4TjBL?=
 =?utf-8?B?T2MrcTFPMTkrd1ZGcVRLVTZJTisybXlrM1dDU2VvUFhZWTNVemtBZnpDa3J1?=
 =?utf-8?B?cDc5WDAwcnJvd25hZXJaazhLZG0yOFQ5ZnExRWdtVzBSd1NjOEZnbEhBMjBX?=
 =?utf-8?B?cWdJZ2N0VlpWSWFHZXdtL2dNOTVCeFUwZjNzblpOQURtVS9CbTAxMklpeXlJ?=
 =?utf-8?B?ZTBDL1FsT3VHaFRzcXJ2THEzSXZHb1ppR3VrVU5wTG01QTl5a3ZkWE9kNFBG?=
 =?utf-8?B?ak5rSmZwV3VyWHlDdSt0eVFsdGJjK0VzclFwTE1FRXBvaWE3SFplck1lamlE?=
 =?utf-8?B?clVMbXNFV3FON1ZpM3BEemRiS0htcnBvZ1VKRlBPNXp2dUpUVVVBaVVESVN3?=
 =?utf-8?B?cXhSSjNLenNPNkVFeEV1OTBXVkVnalpVK3c1SnUvYW11S0l4OTI1Y3NUYVdo?=
 =?utf-8?B?cVNQUVJLbnYzSnRWU2w0ODJ2NFd6Y3QzK0JXR1RVSVhZOE0rRG5INURvWmln?=
 =?utf-8?B?a20xZVlVZGxhZ0lGNitZNGdHN2FqZGZDV1p5a0taY0xTNUpJWlFJTGRCeVFm?=
 =?utf-8?B?UkU0emVnb3dyUHdsQ3RlbDVhL0dZN3RZVjFuaSt5bDdNczNUaDJDVThkYlox?=
 =?utf-8?B?c0RKMW5qZDg1VWw4RU43NEJzNDMyNGdCM3JSbnpDc3BkS3JQMVlURGhXYjU4?=
 =?utf-8?B?ZkJzTEdGZjF5WFZDM0hBeVBPeWMyVjRleVUzMG1JVmd6RitXNUVxZG55djV6?=
 =?utf-8?B?anJiN21qSzJWdmZHZjFpL1o4NHg0SG5RT09PRFdwcDBJU3UyRTd1eExTTkRC?=
 =?utf-8?B?Wm83UDExekVXenIvUGlLb1RJdnJWWm5QWXRVNy9oYmR0VC9Ud3REU1prS0hR?=
 =?utf-8?B?WDRFT2FjQnl2T2NhZXRmeHZLY0dLSHBFejJRQkducTlSWFJvcXlTelROOXN5?=
 =?utf-8?B?WVdVRlY0U0VxdDRCTWNDVlNJT2x3amdkMXl3Sk1BdmlpaENYbmcrSFA4ek5w?=
 =?utf-8?B?dkE3MUJ5bUppMnFMSWVueUgrQTZRQlkzdVBmRm1xbjAySkZGYmJoNXNmLzBk?=
 =?utf-8?B?YjFMNEFsOHU5dklSOWpMWm0waVZLMkV4b0dXN0FmSjRxTjBRMTl5UjJUWmpI?=
 =?utf-8?B?eDZpY0N6TitJc0hadlU4UlRXeXd6bjJRR3NyanNGM3RmTm83NFhWQkZpQ1FT?=
 =?utf-8?B?b2hsMlV6UlVlM1ZPVTRJNkJOaEwrUGk2Yi9ZVU4wdmY4OHd3aDBUcmUxTmdv?=
 =?utf-8?B?eWU2Q21DY1BDenY3MXVuVG9BOFdybHFwdGZ0WEcwWWE1bGtpaVhWMFlYRVJN?=
 =?utf-8?B?TnFHZm5iN20yZTBRRU5UM3JXWFYyR3N4RnhXckgvNDczYlo4L2xsRmQzZ3Ex?=
 =?utf-8?B?aENRZU5lekdYZEVZYlBzdXJWRVNTL05WR2lhVDFsZFBlTVk3dFBKRlVIWnFl?=
 =?utf-8?B?VEdtWnhNcEh2Tnh5SHlYdDYzMWJ1KzhzcndxbHZ6Q2RKby8ybkNiMlZIVWFs?=
 =?utf-8?B?cGhlNVVRZ1J2NTZMYzNIdndrVGxidWhPMDVpbFVWUW9kU045aGhCejFiYVN3?=
 =?utf-8?B?cElxbUc4ZEF2MEgrVWRMRkxkdVVYU2dKKy9mT0o2bVFiRHo2RzE1K0FTNHBW?=
 =?utf-8?B?TCt4dE1PTHRYUEpsMUlrSUtxSDZ1Ylh6RzlkZHF4QlFqckxRV2wrLyt3UWZq?=
 =?utf-8?B?cWdrT2ZFNGZURnJPSUVRL3I2S3NqbUhzSDNOZ3dOc3NaNmYzOGI2aHk0UDJj?=
 =?utf-8?B?VFhTRm80a0k2Z3RuNVU2R0FKQkhTek1oNnltZEt3cUdOTFE1MmVBYVNMN0My?=
 =?utf-8?B?c29zY3VreGNKa1ZzaVBFY0FHMXphSC9DdVd4SXgzcWpiMnJrUkYya1hleTB2?=
 =?utf-8?Q?4VV5orqVFzuUqLPO+4yuZFwgS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c791f00-5166-4df9-cede-08da90f1a021
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 16:54:27.8496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQWQwijcC1Xo1HRqgd7KzBsmjEk+ida77s9AH93c8SOZsgJYY14HH2lw0dWqUL36Lp9gQ5LEkvLbwmPd23kuvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4315
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_08,2022-09-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209070066
X-Proofpoint-GUID: xpUVLqgdtFxIw0b0JDmKLW9W6xyHhE6b
X-Proofpoint-ORIG-GUID: xpUVLqgdtFxIw0b0JDmKLW9W6xyHhE6b
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/09/2022 17:01, Sean Christopherson wrote:
> On Tue, Aug 02, 2022, Jinrong Liang wrote:
>> From: Jinrong Liang <cloudliang@tencent.com>
>>
>> The following warning appears when executing:
>> 	make -C tools/testing/selftests/kvm
>>
>> rseq_test.c: In function ‘main’:
>> rseq_test.c:237:33: warning: implicit declaration of function ‘gettid’; did you mean ‘getgid’? [-Wimplicit-function-declaration]
>>            (void *)(unsigned long)gettid());
>>                                   ^~~~~~
>>                                   getgid
>> /usr/bin/ld: /tmp/ccr5mMko.o: in function `main':
>> ../kvm/tools/testing/selftests/kvm/rseq_test.c:237: undefined reference to `gettid'
>> collect2: error: ld returned 1 exit status
>> make: *** [../lib.mk:173: ../kvm/tools/testing/selftests/kvm/rseq_test] Error 1
>>
>> Use the more compatible syscall(SYS_gettid) instead of gettid() to fix it.
>> More subsequent reuse may cause it to be wrapped in a lib file.
>>
>> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
>> ---
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 

Can a 'Cc: stable@vger.kernel.org' be added also as e923b0537d28 got 
backported to v5.15.58

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


> 
> Paolo, do you want to grab this for 6.0?  It doesn't look like we're going to have
> a more elegant solution anytime soon...

