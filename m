Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0028175D17C
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 20:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjGUSpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 14:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGUSpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 14:45:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED33E198D;
        Fri, 21 Jul 2023 11:45:01 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36LEG82I016592;
        Fri, 21 Jul 2023 18:44:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=FRjUmw+81M8Pp3TUqAVoHyv7+ihSt6mZVzFVmJVnWzM=;
 b=kfrWXLVvBP6lzDueJRpp7yUCJata9ikCU/eC2mMGR0SbPENWgOTHLPS1dbB+ktQWRm3V
 /JgWD9NjWsQvODSc1P112HIrdQiPdjUuoPJsA5IajGpGg8QrfW73Wca0cm4y3kb81IMt
 1EE5Qy+psB0NVCtYep7Gj82/n1LCLeNIcrD1Qotmq44RJScKTNExaEqK91cq/bszFCmO
 KsixPOZarWwciCLjzHaAKMDwJ4h29Zsx1g/Ufv/06ed9pyiaIkgjtQW5eWAUMA+iUjBB
 cQUE7zfDzQWygRlfPROyUPlJf9Z4WPIe7Y7+cYQrO4rC9Nd0F2uIacb7/zQg2UQRKgfD ug== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run78ccc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 18:44:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36LHMaYe019188;
        Fri, 21 Jul 2023 18:44:34 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhwatnbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 18:44:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWV7ToLrSI3qXB25oo1r4vNdXrlH6Rf2PUAogn/yRTynSRyrPtPYp6lKx4CEwJzzwI7slShDYn1kxpVYViIeJ91o1R4K0Q9HGkVj5XWSi6KxHtLFqfwqdcejRn1XBUB6AjzeO8TmNqTFrO5vl8CgTpDNLyBpD9jLyRffpy1ouoQoxl8DbvzZ+OVqH8FujqvlIICIM9YGs3+yulUdcBsgGW9scHMoQBwptGaYqb/NbS3eUoE+D+mJ09VGSJFt7vbimEld2VcMkJkE7swMM5huBWzRAXz2p6MplbZUSA/h8HQEJqQN8voCuOGRklC0yNelXiVZgcgdnyz4H4dAZw71/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRjUmw+81M8Pp3TUqAVoHyv7+ihSt6mZVzFVmJVnWzM=;
 b=ZQjfGwrquYDg/Yx0oDxdDK83riQePPC22/qlUQ1wnJbEMeCkLLXcGFWDhI280vusthuh2o+tDlO4LrTMXbD1EUsYu3ML6LqqY9AuOSMI6qGhdlZfXaGZQAp7mO8bZZ3YEcyzMw1qoV5H4eRaAGdZl0HCbRgQv98lHFSvOtqkm1/rtKhTMzmvpUzejkRyvp+qJhXws2F7ve9bLTnt1wYOufnfFKpcb/uAHH5EaWNb4DJobTbdqyzOcvyXscWb9OoxJVzeZIFH4kzaqjyoisJkhTLFQPykjvAb35Cvz2dlM7uf8/O05yGuVkb3zSHTHjsaXzqtpVqrpqlQih11XgUdTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRjUmw+81M8Pp3TUqAVoHyv7+ihSt6mZVzFVmJVnWzM=;
 b=k2dh3yr91CY6c3AP3qvEKidrbe1fh4hAG4bC/QWDCdEk2J75PvTOyaplUBgkPjrubZgg7RT86ET2e+OUF76FIU1KJxWm/UkK4yA/FRZ6ZtOSILBaADG15LPN0RiC6oRyKbnbJWbgORQNpZukc/gA62BdL5c3Zb3AzPoIOsRhLcM=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 CH3PR10MB7612.namprd10.prod.outlook.com (2603:10b6:610:17b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Fri, 21 Jul
 2023 18:44:32 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::26c8:9b4f:8cd0:817c]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::26c8:9b4f:8cd0:817c%7]) with mapi id 15.20.6609.026; Fri, 21 Jul 2023
 18:44:32 +0000
Message-ID: <caefe41b-2736-3df9-b5cd-b81fc4c30ff0@oracle.com>
Date:   Fri, 21 Jul 2023 14:44:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] KVM: SVM: Update destination when updating pi irte
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Joao Martins <joao.m.martins@oracle.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        "dengqiao.joey" <dengqiao.joey@bytedance.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <3d05fcf1-dad3-826e-03e9-599ced7524b4@oracle.com>
 <20230518035806.938517-1-dengqiao.joey@bytedance.com>
 <2f6210acca81090146bc1decf61996aae2a0bfcf.camel@redhat.com>
 <36295675-2139-266d-4b07-9e029ac88fef@oracle.com>
 <ZJ4HJhQytonABUMl@google.com>
 <bae58fd3-34b0-641a-a18b-010d48c792f0@oracle.com>
 <ZLgH+LGl+eC4hFdx@google.com>
From:   Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <ZLgH+LGl+eC4hFdx@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:5:40::34) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|CH3PR10MB7612:EE_
X-MS-Office365-Filtering-Correlation-Id: c582f990-4a92-41c6-f379-08db8a1a856c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ghm3HAccI+yLyL+Z1K5BfqN2EzR/lqSy22r/8kRR/UDTdxpienIj661hWv/K43hxYuH2q2ruxbX4HsubDSkITy0JhV5a7w/Iq7wP2UEgoTX2ce1VNgcySTEyGnl2nq2doKsgKDXdbWgQ9vMXsF1ORRVvhzjbAJowKhlnWxNcWLdYRbCZPlnkZQ2BCG4h49ueHB3MlHrRvag7ZJ6SowUbddN+GCdRGelmjuveFtFWwFdLA/338ujkhnGQbbpCfPrIlqiUCPbL9+Y6jfqY5YQY43RZqacQtMcGZ6koczlDHyh715O917rshgu/1gkGTDCYh8jS5gp/C2FA4Pd+U4qr+2pXjQSIoUi00bB4x8x6X1LZGu2t217LLTPIIaK5jcrxCJqNBkWKOhm4xNOf3WqTVJ/3wuwSOBMj5QbG4ZdU6iaIsxUvUt85o5W4C4k/nrpJ2JHReDR3/Hm9v+zZd+F+ACsTfpC3/aw8v+4ozMvYTjhLU2UFgbdFrWi5Pra53b4FGDAIkmhkqZjdZyTwn0aLVRisPpPh+7Qa7dSDvtRI5rEdIJMYUndFlGMFlA/1MPC+Gdm6fG3x9YlnrHiE1CXylh84NZyZEx6e/1MUMcNoBGWqtq3zlExIakZuR+9xTdjFOzmTGOzSJ6qq4krSuaK6EA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199021)(4326008)(6636002)(31686004)(8936002)(8676002)(54906003)(66476007)(66556008)(41300700001)(316002)(66946007)(5660300002)(15650500001)(2616005)(6512007)(2906002)(6486002)(26005)(38100700002)(478600001)(966005)(6666004)(110136005)(36756003)(186003)(53546011)(6506007)(86362001)(31696002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d001NitLajE1QnlSWlJDOFlFcGoyNldleHJlUDdlUWRFbWd1TFFUbjh0bkg4?=
 =?utf-8?B?aUFxYm9UOGRkOFZKeUpGWFp1bVkrb1FkQjZtZlQ1aUEvVU5hMUd2REtYclMy?=
 =?utf-8?B?amV2elk3Z1JaTzJkczZGZjgrQUxHcWFhdDkxVWJHbzFZS3lMR0Faa1V6YTYx?=
 =?utf-8?B?eWtnQmY4QS9OWEd3dkhtb25BSFAzelM4RDRNaTFrMDlSb2puRDF0VjIzRWR6?=
 =?utf-8?B?eW0zdFFnQnFGQ2V6K0l4c0d1ektyYWdzV2d1cWZrZkd0UExvRjRLTXdBWXl1?=
 =?utf-8?B?ZkZRamVQaG13bTliMUZoUkp3Ni90SkhVWGI5WUVkelphU3plRGQ5RFdlRUVs?=
 =?utf-8?B?dUwwQm9FZkZqc1RWT1k0QnpFYjRKZjJtVjgwQVNheDNPUVVtUTEzaFZHc2w0?=
 =?utf-8?B?TnAvbTV5dTYyUmdxajROaW1hUERHbmcyTWIxaHp1RUhiNWl1S2tqVEl1bGdz?=
 =?utf-8?B?UzJsQ3dkdktUVThjWVR3cHVyZ3NkQm53QkprUFZNenp6NEdGTStXekVDQ2tX?=
 =?utf-8?B?QmsrWnVQdW1rUTJLeUJQZzdHSVFyTU5xa0VjVHBRMy9HaXdSN3hHYWpidHAz?=
 =?utf-8?B?K3locjh1QVJFNThzdTZNNEQ4R0c2aHhzNjhUNzRKWkovUUtlYmE2NTg3MTZO?=
 =?utf-8?B?WDVPSFFFTmpMeGNORUlxUERlM3ZTdHFOTEhweTdNY0Q0cVpSUTBWT2p0OGl0?=
 =?utf-8?B?Wk53amJqTkJJMlJqUDljRkswYlpRWTNvTGdlV0l1NTloeEcxUVBoOHJBejh2?=
 =?utf-8?B?Qk53TGZpMzgwYTdld2UyUEZqZ3NnRFI5Q2R6WWdlTzFjR1FIcGcxSWw3QXlV?=
 =?utf-8?B?aFNHbUsrMFhDNEZVY3cybUdmUnRaMjRtc2dMVlFUNFlxc1ltV3ZZcVVGL1lm?=
 =?utf-8?B?cno1anV0d2xuMnZUQmpGVzRhczRvMTJyVmt1ZWlIWlJNMDJRejJiY1lCak5l?=
 =?utf-8?B?RHFLQ1NCeHM3YXhSQ1ZDYmpsMFV6ajlSVkxWeU1XR0NVTWprdmM1c0JUNUR2?=
 =?utf-8?B?a1ZwUnI2KzVWN3JsdzhqcXVkRVozTng2T1pKZUhOeUtzVzFMS1V3aUE4SFdK?=
 =?utf-8?B?OHJ6NjVnSXcxOExFN2YrWkNmN2FXc0JOcU9sdHhyYmJQMiszSG5menRUN2Ix?=
 =?utf-8?B?aVFjb2trUjNUS2dDcUl3eHErckdGZFBUS0JvU1RuSHBuRlZBVnZFMCtscTFz?=
 =?utf-8?B?Q21oUTNBWEh6ZGVBOThXTTRBMUg2Y2FXNlUxcVR5cVd5SzVWMVRHeGNoYTEv?=
 =?utf-8?B?N3loNTFpejhJcW0rT2pCbXVBaFgxYzB2dmVwNVNDTlRIUlkvSldhdnJqOWc0?=
 =?utf-8?B?VzgzNml1eThMWVNSWExZRFBWRWZ3a00vaWZRMHhTRGRLVmtTUmE0SVdrU0hx?=
 =?utf-8?B?OWtGSjlZeTVqOGpZSHB5ZGp0ZUZ4ck9vVXhHUUE1dUk2SWNWWDBUcE5FK01o?=
 =?utf-8?B?dUJMMThCempIc2lCMUZwOGQxZTRsSGRKVmlqRzRKVzgwbm9rVzd3c2gyOWNS?=
 =?utf-8?B?VGx0Zi9Ccy9vTkFsZm81QVNaMGI1ei9KS3hmbkovd2VhSktEK2MwYk1qYnBz?=
 =?utf-8?B?U2ZacWc5aU5iT0dCNHVzV1J5eFJHLytSZTZxMUF3bW5MNFpYeXZMaUQ5K25X?=
 =?utf-8?B?bW9mR3NvRy9kSWFzUnJ1c3loQTZRVUh3ZlJMT0N1V2ZXallhMnIydWNKb21r?=
 =?utf-8?B?R2diQTE4YUVvS2pRSHVSUXR2UG0wNFNhbUNzVnYrRXIzSWdleitML0VqdEdv?=
 =?utf-8?B?bGNZYjBTcVR3V3A5RVJ4dVZUa0hJbWdwZ3A2S3YzZ1oyazM3UVZqeUd1eGd1?=
 =?utf-8?B?czlIQXdYY1dFR2pidlJyT05kTEJISTVHcEwzLzVSN0Jhck1NUEZYUFc3eU56?=
 =?utf-8?B?ZGp3RUx5MjNKNGk0VmFHYVZMcjRDeGxuNDVTeDVKWnlCTUpQRGc5WDU5bzB1?=
 =?utf-8?B?NytoTEZtYkFkQ2s2dURQTU5JUjJoQUI0NjFKM3ZtUk90MzNiTU9FTTR0bmFF?=
 =?utf-8?B?U0k4QXhuWWtyS1ZsSjIwMkpaU3QxZGU4Nk52RzZZYnh2WG5yMnFNMjNkY2NE?=
 =?utf-8?B?K0h6WURJRG5tNW12K2NIWnYzRzVKVmdYSjM4bzB2Kzl5ZkdpTEVaQVNiVTBs?=
 =?utf-8?B?TVRjalJkdzRJS3VjNStnSzZPaHF1UGhxNlp0YWtTT2RGVHRRRXY5ZFhNL2p1?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bOZkeHp3+7a2aeDl0gqyzuYL4T53eDMwylIgQY8EKkDzV++y2C7PZlOZT4+F7CaDU199T5E+sNN7BAiVrSSjg/d60ytRHHuEid1Ee0XWn3nOHgn5Iz8mG8oQKgAuRTJfDxW3Jksg9f3bTlauCSSJRpWdpyQLy5ZXhQPkwjTQPUUiAnEC/U2uBXWgz39eQXhcQCRxR6kDNwqg+XAqWo0R7D0U+zerHRVk+UyqqUEbBGReQTa793obKT1nzTAf/cy/sjndM511Ff7c4w4NBP50cW9V9eKGq/wHiLKFrGn236uiy8ajuo0MzW1ilqWixyrEaEZYUcLuHENOxPzdnTVw7YSAJN1TvkMUriqi0jRPon/9/Thr5ZHh6IT6j5aaai5J8zdCD1bdbZocTlMueYAoq0oa+1YolxlS1TdZ+w15+P5XDP1AGJbwgZ4njlQENZ2RzH7HjgjawqhEpdGS350jIbaWMxM4BfxSzFglZHSkIz9sP4xKj1qyNkGUbUMq2P7frELGOK+IXfnkO1yUtvVEl0UwXQbMWHjlPILwNssjfRoMLeLNqYtO9x21kHgZIAOdP67vUO/ODuG69/QuWD+q2LD0quAOO9GAHHDSfQDu4/QClAOsBSmUrBD7IqCx8zsqqZLecYcw7a4FQAqm5fwmfNjdA1c3a0jOglOvo/RpdPbMzPZ4w3QXUcFeX4vHs/Z+i0vPw5lmHD2U9lzzZ6nkuw2dCmO/+aPRClOvfM/b1s0AkVPKw/4PA1SgaNMMGvrPtRDc0t5ceNvs65HN7kcprL8p5SrhuGoY1daUZyYxwjbI1mYxKcvaifmVTZJNGwC47fHqWXtNRXz9+unyNON9C4Iwzk4ztyy9W9TxxF3nOLCQnsTZH4mG595uEvv4JTFM
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c582f990-4a92-41c6-f379-08db8a1a856c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 18:44:31.7905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ccAgIjasnDWc/z/Gts4Y6aPYiB3Aa4iQvJLSIk0SVVE2kItYOOZm9Hz+ia9qi01K2FtCVem0b/zQWlWvJQraY+2QpkSBggsNjc/z4sUl4I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7612
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_10,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307210164
X-Proofpoint-ORIG-GUID: aH3MXEOfRSWTLmH3rpgwho3kAQT4m2vs
X-Proofpoint-GUID: aH3MXEOfRSWTLmH3rpgwho3kAQT4m2vs
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/19/23 11:57, Sean Christopherson wrote:
> On Fri, Jul 14, 2023, Joao Martins wrote:
>> +Suravee, +Alejandro
>>
>> On 29/06/2023 23:35, Sean Christopherson wrote:
>>> On Thu, May 18, 2023, Joao Martins wrote:
>>>> On 18/05/2023 09:19, Maxim Levitsky wrote:
>>>>> I think that we do need to a flag indicating if the vCPU is currently
>>>>> running and if yes, then use svm->vcpu.cpu (or put -1 to it when it not
>>>>> running or something) (currently the vcpu->cpu remains set when vCPU is
>>>>> put)
>>>>>
>>>>> In other words if a vCPU is running, then avic_pi_update_irte should put
>>>>> correct pCPU number, and if it raced with vCPU put/load, then later should
>>>>> win and put the correct value.  This can be done either with a lock or
>>>>> barriers.
>>>>>
>>>> If this could be done, it could remove cost from other places and avoid this
>>>> little dance of the galog (and avoid its usage as it's not the greatest design
>>>> aspect of the IOMMU). We anyways already need to do IRT flushes in all these
>>>> things with regards to updating any piece of the IRTE, but we need some care
>>>> there two to avoid invalidating too much (which is just as expensive and per-VCPU).
>>> ...
>>>
>>>> But still quite expensive (as many IPIs as vCPUs updated), but it works as
>>>> intended and guest will immediately see the right vcpu affinity. But I honestly
>>>> prefer going towards your suggestion (via vcpu.pcpu) if we can have some
>>>> insurance that vcpu.cpu is safe to use in pi_update_irte if protected against
>>>> preemption/blocking of the VCPU.
>>> I think we have all the necessary info, and even a handy dandy spinlock to ensure
>>> ordering.  Disclaimers: compile tested only, I know almost nothing about the IOMMU
>>> side of things, and I don't know if I understood the needs for the !IsRunning cases.
>>>
>> I was avoiding grabbing that lock, but now that I think about it it shouldn't do
>> much harm.
>>
>> My only concern has mostly been whether we mark the IRQ isRunning=1 on a vcpu
>> that is about to block as then the doorbell rang by the IOMMU won't do anything
>> to the guest. But IIUC the physical ID cache read-once should cover that
> Acquiring ir_list_lock in avic_vcpu_{load,put}() when modifying
> AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK is the key to avoiding ordering issues.
> E.g. without the spinlock, READ_ONCE() wouldn't prevent svm_ir_list_add() from
> racing with avic_vcpu_{load,put}() and ultimately shoving stale data into the IRTE.
>
> It *should* actually be safe to drop the READ_ONCE() since acquiring/releasing
> the spinlock will prevent multiple loads from observing different values.  I kept
> them mostly to keep the diff small, and to be conservative.
>
> The WRITE_ONCE() needs to stay to ensure that hardware doesn't see inconsitent
> information due to store tearing.
>
> If this patch works, I think it makes sense to follow-up with a cleanup patch to
> drop the READ_ONCE() and add comments explaining why KVM uses WRITE_ONCE() but
> not READ_ONCE().
I tested the patch on top of v6.5-rc1, to also use the host kernel param 
"amd_iommu=irtcachedis" from:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=66419036f68a

and found no issues running a 380 vCPU guest (using idle=poll), with a 
mlx VF, on a Genoa host.

I didn't run an interrupt intensive workload, but stressed the affinity 
changes in a tight loop on the guest running:

--
rcpu=$(($RANDOM % $(nproc)))

# the mlx5_comp* IRQs are in the 35-49 range
rirq=$((35 + $RANDOM % (50-35)))

echo $rcpu > /proc/irq/$rirq/smp_affinity_list

--

As suggested by Joao, I checked to see if there were any 'spurious' GA 
Log events that are received while the target vCPU is running. The 
window for this to happen is quite tight with the new changes, so after 
100k affinity changes there are only 2 reported GA Log events on the guest:

--
@galog_events: 2
@galog_on_running[303]: 1
@galog_on_running[222]: 1

@vcpuHist:
[128, 256)             1 
|@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[256, 512)             1 
|@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|

--

where when running with an unpatched host kernel there will be a 
significant number detected:

--
@galog_events: 2476

[...]

@vcpuHist:
[0]                    2 
|                                                    |
[1]                    1 
|                                                    |
[2, 4)                11 
|                                                    |
[4, 8)                13 
|                                                    |
[8, 16)               51 
|@@@                                                 |
[16, 32)              99 
|@@@@@                                               |
[32, 64)             213 
|@@@@@@@@@@@@                                        |
[64, 128)            381 
|@@@@@@@@@@@@@@@@@@@@@@                              |
[128, 256)           869 
|@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[256, 512)           834 
|@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   |

--

The script I used makes assumptions about strict ordering in which the 
probes will be registered, but given that the observed behavior is as 
predicted the assumptions seem sound. It is pasted below, in case there 
are concerns about the logic.

Thank you,

Alejandro

---

#!/usr/bin/bpftrace

BEGIN
{
     printf("Tracing GALog events between affinity updates... Hit Ctrl-C 
to end.\n");
     zero(@irteModified);
     zero(@galog_events);
     zero(@galog_on_running);
}

/*
  * amd_iommu_activate_guest_mode() is mostly called from
  * amd_ir_set_vcpu_affinity() to process vCPU affinity updates, but it also
  * gets called by avic_set_pi_irte_mode() for re-enabling AVIC after 
inhibition
  * so this data is unreliable during boot time where most of the inhibition
  * events take place.
  */
kprobe:amd_iommu_activate_guest_mode
{
     /*
      * $vcpu_gatag = (struct amd_ir_data *)arg0->gatag;
      * pahole -C amd_ir_data --hex drivers/iommu/amd/iommu.o
      * shows offset of u32 ga_tag field is 0x40
      * AVIC GATAG encodes vCPU ID in LSB 9 bits
      */
     $vcpu_gatag = (*(uint32 *)(arg0 + 0x40)) & 0x1FF;

     @irteModified[$vcpu_gatag] = 1;
}

tracepoint:kvm:kvm_avic_ga_log
{
     $vcpuid = args->vcpuid;

     @galog_events = count();

     /*
      * GALog reports an entry, and it's expected that the 
IRTE.isRunning bit
      * is 0. The question becomes if it was cleared by an affinity update
      * and has not been restored by a subsequent call to 
amd_iommu_update_ga
      */
     if (@irteModified[args->vcpuid] != 0) {
         @galog_on_running[args->vcpuid] = count();

         @vcpuHist = hist(args->vcpuid);
         //@vcpuHist = lhist($args->vcpuid, 0, 380, 1);
     }
}


kprobe:amd_iommu_update_ga
{
     /*
      * $vcpu_gatag = (struct amd_ir_data *)arg0->gatag;
      * pahole -C amd_ir_data --hex drivers/iommu/amd/iommu.o
      * shows offset of u32 ga_tag field is 0x40
      * AVIC GATAG encodes vCPU ID in LSB 9 bits
      */
     $vcpu_gatag = (*(uint32 *)(arg0 + 0x40)) & 0x1FF;

     /*
      * With the guest running with idle=poll, avic_vcpu_put() should not
      * be called, and any GA Log events detected must be spurious i.e.
      * targetting a vCPU that is currently running. Only clear the flag
      * when setting IsRun to 1 (as in via avic_vcpu_load() or
      * svm_ir_list_add()), to capture the spurious GA Log events.
      * arg1 ==> isRun
      */
     if (arg1 != 0) {
         @irteModified[$vcpu_gatag] = 0;
     }
}

END
{
     clear(@irteModified);
     print(@galog_events);
     print(@galog_on_running);
     print(@vcpuHist);
}

