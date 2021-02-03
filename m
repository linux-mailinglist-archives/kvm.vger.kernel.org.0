Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329BD30D0C8
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 02:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhBCB3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 20:29:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44966 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhBCB3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 20:29:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131OupJ149816;
        Wed, 3 Feb 2021 01:28:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=FCHR/kvHlyKbKvUjMwXY42SxTz0rqXup5nfnNHN3YTM=;
 b=EfltPI2s+3xRAs77ZI2xrGajo24lLXWUO37Fmlhffg6RFvZtL8WeFctc7qxrS1zQuuvy
 vFELBmd/xlBmzaD/f87cyW6sJZ4a4zt1na10NJ++KJrSHc4TDheB/io8MME4QWyXkhdf
 TdlZkhQOcjv2elc7IJBbSS10LEbCIfcbXsPD3OdCEGyFCvSWr5CWNJLeZrTBXjtiLjFN
 lsqkMgkeH4rg2GB9QS/9mS77L79MD3xf1FRwmmIcNarAv7Vsd0fprDd6GH3+kHjmlwPy
 3n71CPrvxRmBMEa4fFXxJ2Y1dJ/cGxtqWFOuaK+DZHOOdCdRAhUAys4EyqBkfcTcaoea xQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36cydkwkrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:28:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131QYoG100957;
        Wed, 3 Feb 2021 01:28:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3030.oracle.com with ESMTP id 36dhcxnvx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:28:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+oYAMwt+iEcgWsN/JP0Jtlf4KPkWKbrR/+wOmZyq1GDPbVlZvcqzwc5YOD+ux/Gn7HUU6lVwtdC0kN7sBXR28KbcL57zWbZmtyky6r93vlhjynIXMEZ7BBpufUCvqttWStfdD8wsHdqmQNIouH4OPBy5LMRb83HqT3b03kKamXlktcP9ujLH71m7ghrNaLfYUDNGgb9A5MgzZHcMunh/VWMELlBSzwX5EhZpX/mRT08uMjF1v6COAW6rehsP4qlkjYJKLsDh5syVhFclvCqGHqJczFPUyb8onmk3hSoZNcRjxoEXGHXuKUIbGzRczuwqQNeq+VxTdS3RGlUSB3gpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCHR/kvHlyKbKvUjMwXY42SxTz0rqXup5nfnNHN3YTM=;
 b=RLpXINKU7yUHv5x3UJlUUYLV0pDRVvMOH/hEekvuVbd7lsQfU2sXO2+wQ/FYpbo6xbn5Wp0nU0gsQ7bOT1Y1INAR1qIQwfqOGgrxqNpH+cIj+ATyxAuNGb4ZvpQYqFmi782lRyx+KKEfaWaI/rm62Z7nFEWbp8Bq0lWaKI2b3v75x6ci2KYik9PfHYz8OUwXhJUTHjjJUTR1WpdhKTZ5xUZBh4DdF+vQL9tqC5UGJ7xgimBlQGQzQ4N3lxy/rjUA9JjvO8oUI0HREnkrZ3Bb2nZ8myeBxdV3PcHys6z14N81JzePp2WPl68A4M0IZ7l6yCIUH5/qlBXmZfCAZGYKsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCHR/kvHlyKbKvUjMwXY42SxTz0rqXup5nfnNHN3YTM=;
 b=mE6+5lbQ4MbVrQS6S6+RIstrutPzlci3XDSgYwGnsm7UWJLbj72gLT2y4fF1U8QWscGXJ3bhsT4vA6JYjByMUSrCz6ohmyo4miZUmYiKq43LmLm4AbTzvhkgC9M7qzt7LDUrTazblGxKIcrYmbGth3KEtyPvf6g2MEaptXzfjtM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DS7PR10MB4941.namprd10.prod.outlook.com (2603:10b6:5:38f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.17; Wed, 3 Feb 2021 01:28:43 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::29f2:ddd5:36ac:dbba]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::29f2:ddd5:36ac:dbba%4]) with mapi id 15.20.3805.024; Wed, 3 Feb 2021
 01:28:43 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 5/5 v3] Test: SVM: Use ALIGN macro when aligning 'io_bitmap_area'
Date:   Tue,  2 Feb 2021 19:40:35 -0500
Message-Id: <20210203004035.101292-6-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210203004035.101292-1-krish.sadhukhan@oracle.com>
References: <20210203004035.101292-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: SJ0PR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:a03:332::18) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by SJ0PR05CA0073.namprd05.prod.outlook.com (2603:10b6:a03:332::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.15 via Frontend Transport; Wed, 3 Feb 2021 01:28:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6964ade2-63bc-499c-aa10-08d8c7e30ad7
X-MS-TrafficTypeDiagnostic: DS7PR10MB4941:
X-Microsoft-Antispam-PRVS: <DS7PR10MB49419BE5F355F750B7DF8CB181B49@DS7PR10MB4941.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ukxZcoi+thZwMoZ2jay62JF0iTmfdDNpdLamwLKqsHhW5thSfN/0Km8yE1ANhsowBHtmOeU6jA1WcRej3bKAQMo1jzlok4qm8Il2iPjm3Jzr9E46d5GPBQ7XxmRrf884cHslVwChQsGvVWJn5FPHdjtltJHqooNqlAFrp8wmFiOeQbqbXDBeahaolcYIuDtbT+Vk3OgI3yDpqtuxABnBIhSFCfT0Zba99qHTg03aPVZXKGjWhwyM4n7UiPtTS6Bzm4Us3PdD5NpVszYURPNlaQWBTN1UcKPisoT0VWULgueISGNDna+jVKHCJ7TSC62Xqqo/M41D6yzSA2Z5GhbNNQK3tY9TMMbjwXoVgX1+jGMBDjyOTr0RE4zUFn8c8BOM1n8Vlo5CC6JCwsOOarWz9elpD8NegzG7f58/cquXHJmzAWYzEt6s43a58X5kffn2Cnkr281lwccOaT7c08JDcGdGgFEDaR57OW+wXmQF4h2hi6xIYugno05TUWdO4aT+HDWRYgj63V0eAe5HAZUfJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39860400002)(396003)(316002)(36756003)(7696005)(6486002)(83380400001)(6666004)(2616005)(8936002)(1076003)(66946007)(2906002)(186003)(4326008)(5660300002)(4744005)(86362001)(6916009)(66556008)(16526019)(44832011)(956004)(26005)(52116002)(66476007)(8676002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?clk0otcLCgZgcdFeQA95ihje1q5Ax+iERmCU+xYKsBmbLHItXUas7QI9eP8x?=
 =?us-ascii?Q?FctBc3RYGa/3/KVGdmQatbtB4HnvPFq1ccV4eSnKMjzAaQO4MwBSU0OLydef?=
 =?us-ascii?Q?XT9t6ZUQnbSanMkfMw3+T0aZWZPyjqGJzxFIHneATaewE0nX5uH4eqOa1Scg?=
 =?us-ascii?Q?/zJOS3N8HCK2eVoyEyLh3JX9mScvjov4FfU17CVNhG5XR4nMd+Xwjf4lRPYf?=
 =?us-ascii?Q?Ymsx9mQL79kdPIgESOlhbmz1ZbJI8bDTs0ul0jHWGKiQ93+8RnCtgkEDVZvf?=
 =?us-ascii?Q?npGyeEhr3IdzDprx8If4d8bzqIVOXr38C3BwfSkTnTR1eYSdoLWQ3xINLi83?=
 =?us-ascii?Q?iUsFhEClO3G633P/wwz02ngJG97woEFWhHunJUq9x8LxImdcuGglivu8URC0?=
 =?us-ascii?Q?oNf1Agpp4fipJAepuDxdFRom83YzzFWpF9wp4bAsxOhVDdgjzsNqBbPEVTT+?=
 =?us-ascii?Q?2d50d7s6tXpM+LB14HGhjX0Hw19fUfiyK5XWp6QzfOLnl8PXLYKHFkKoLAWi?=
 =?us-ascii?Q?njEUMqwpZ2yKPsi3DeQqJm4pI2jyIKMyGT1LE+fKBt1ypLPajX7MuRaLYG5U?=
 =?us-ascii?Q?+vVJo8VuUNdJXRzwcNHPR+Q7KvHb+lZnU+J3xuffDmKysWMRsiNGvPO5Ffc5?=
 =?us-ascii?Q?LQI0IXcujJLL8vY3vst/0+nmoq7DwVjPKNbbStr38roO6/yVxx571PxZtTHV?=
 =?us-ascii?Q?D3iCku89LBf/qekt7SiA+HkSF1fFDaah6TMSHw1dky5WDqGK4mZYaaOo3jX6?=
 =?us-ascii?Q?OcEkl1cBGM5daQddeVb++d4sMez8pv5MF/bopY7sFqKbriMubgoQkKZOpitI?=
 =?us-ascii?Q?ZtHrdJRdNNeVKMBZGhQ5WdNRVf3o1MElu/RtWJagDKuI1dT4oRJkdHKDJ9w1?=
 =?us-ascii?Q?QX9wQh3InBwTSisuqP9NqXjYJL2gl6Bpz0u3CT9uY2lX3sVIE7CdU6V5dl5b?=
 =?us-ascii?Q?UH3rGcoitnXdKyQO08hZbVZIuxFgZAyfGEH04E8CqtSWfAGglJNu0edpIf/E?=
 =?us-ascii?Q?cZYNUHoch+uBt2vYmjas023lZ9phzHxqFfrqB59jssnCEIXRBqtNGhCW8ASa?=
 =?us-ascii?Q?Lgwf4fun?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6964ade2-63bc-499c-aa10-08d8c7e30ad7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 01:28:43.0262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XD2nc7iUPgWjcAOkWN1SJQkPL+Eua1Y9af9sQ8SRF4aN/aFcrjARs5TKXNZsEEtWF+HkzC5TEtScjOdW4NRUHCaC/fuLzfd7cGWrgypnRls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4941
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030004
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the macro is available and we already use it for MSR bitmap table, use
it for aligning IO bitmap table also.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index a1808c7..846cf2a 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -298,7 +298,7 @@ static void setup_svm(void)
 	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
 	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_NX);
 
-	io_bitmap = (void *) (((ulong)io_bitmap_area + 4095) & ~4095);
+	io_bitmap = (void *) ALIGN((ulong)io_bitmap_area, PAGE_SIZE);
 
 	msr_bitmap = (void *) ALIGN((ulong)msr_bitmap_area, PAGE_SIZE);
 
-- 
2.27.0

