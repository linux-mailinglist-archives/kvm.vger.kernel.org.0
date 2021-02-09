Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8E4314C81
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 11:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhBIKFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 05:05:47 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40852 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhBIKDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 05:03:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1199xsBn021108;
        Tue, 9 Feb 2021 10:02:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4jM1j4Vwf4VglQmZFKQgkQiugNd3qcVmiATsMJQLoxI=;
 b=VScqSb743w+awfZ9ACKrmkho5ris+nU7BE80xTqBGEE/T6mjQAuD9Q5z4gJ5dPh9cx6r
 R7b8mRuPycI/DPqq5hmjEPed9VBpjoDKOUECQiM5DzZjJqdAlrraXTKNRoBi5zmDlKoF
 /OA6t9ZVJqX+PNuH8Jt4xE2r3orIr1pLvf7FBkAtq/I824fHCWPZf3SaySrcpLZNl34f
 qQTGtr16v/ThyvrZB6dMj2qWn85n+6bnJZ6C8jZn8b2ESFah1f3wsl7hQDnbg2b0ltCR
 wTuTym65kV5EWnXZOioGVGQi8t55DNKow2XBBBnUuBVYlhvNw2rvRNqLa7tpwkg7TMA7 Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36hgmaf1g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 10:02:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119A0dIj157766;
        Tue, 9 Feb 2021 10:02:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3020.oracle.com with ESMTP id 36j4vr3yuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 10:02:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Am3wrlWnoBH1ve03wRvXjPio04z375aG004dRYeE2Cp4x0Il7XxOf/rncH6W6LLFiArO5qcCdaWIuG+6hWBc3/U0Li4eNiiM9bnFQbXUupCupzVAoonp6YXIZjM6jRj+zSNu0g7J1kctqYvOLzmubHY4FeZi20BF/jdOYMrey1BghZX2IVS0Fyl5L3s9Cet3jV6anefvt+OyR0ae084Dxtd/zxT72XVCdYtuhISBh93JKyJ/TN55QUv1gzhwfSinsr1WrrG1YCLvaw6rBGNtQiz1garjb1UZ5WGd3lP6Kn51TgpCAnGsU9GBMnqXzC+F95dWK7Zyj3rYTZdekpkEHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jM1j4Vwf4VglQmZFKQgkQiugNd3qcVmiATsMJQLoxI=;
 b=bazThkq/BtaClrmr2btS6zndj/lhRZutvFxxjAdf/pF3nPQqgIyKce3Yar4uA0isql30xSfTZTl/K13FbHxRTCw7REuJfXJr/vlw5JbqWZLdhCoTcehRb0zZAPvQzJFBNMg0O9ReXJTc7jM2cpi+6d1PS6kJ7aLGuf7Gzd07xXbEtjGH/97KjNdT3WrFnxLNZHTSmLjTJDQxRNfvb19jgPDwZb+v2sGEwhknpOFdjP2JOnWll7sEgCxmTvtU8RUr+T7BfRb+lKS9Mkzp/e8aVKGuMHRwTdZDqyCiUzthehVt1bbZQiuWMal6YhvxUtLwQsn8Xs6odu5LGm9q/eRN9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jM1j4Vwf4VglQmZFKQgkQiugNd3qcVmiATsMJQLoxI=;
 b=ry9ojhzqAocvWsFNpn6kyJ2s3ExM9HILNKS8lVHDytGkeAg7yDuQH4xRyc/XovlVyn6ErKyXZ9HryAksn6XnD6ndTvh7voEWmddsCOvSmNecbhthgkaDnMysI1ozhmSnbyRaCmFaQa5nQD7FoMFPEw67A/T3DDlfJGk3eAa7bQU=
Authentication-Results: ziepe.ca; dkim=none (message not signed)
 header.d=none;ziepe.ca; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3077.namprd10.prod.outlook.com (2603:10b6:a03:8c::12)
 by SJ0PR10MB4512.namprd10.prod.outlook.com (2603:10b6:a03:2dc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Tue, 9 Feb
 2021 10:02:20 +0000
Received: from BYAPR10MB3077.namprd10.prod.outlook.com
 ([fe80::74a8:8649:e20b:d571]) by BYAPR10MB3077.namprd10.prod.outlook.com
 ([fe80::74a8:8649:e20b:d571%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 10:02:20 +0000
Subject: Re: [PATCH 0/2] KVM: do not assume PTE is writable after follow_pfn
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Peter Xu <peterx@redhat.com>, dan.j.williams@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>
References: <20210205103259.42866-1-pbonzini@redhat.com>
 <20210205181411.GB3195@xz-x1> <20210208185133.GW4718@ziepe.ca>
 <20210208220259.GA71523@xz-x1> <20210208232625.GA4718@ziepe.ca>
 <20210209081951.GA1704636@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <abcace40-d691-a630-a751-f52f24f832fe@oracle.com>
Date:   Tue, 9 Feb 2021 10:02:11 +0000
In-Reply-To: <20210209081951.GA1704636@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [94.61.1.144]
X-ClientProxiedBy: LO2P265CA0304.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::28) To BYAPR10MB3077.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO2P265CA0304.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a5::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Tue, 9 Feb 2021 10:02:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ce0003a-780f-46c7-a17e-08d8cce1c9fc
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4512:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4512EC08B29CC1B38FD84AF6BB8E9@SJ0PR10MB4512.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X3kN7MHAr/BFX2RlET6/zZTktQquUzqSMYUhrABZoiKjp0fC7dN7WZl5fwrPrK3YuylWt6jb4UqvYIhRI8OYghhdVCfMzC0EmbGsFimILHEmt/vTS4H/AzcRnxnQH5DMKYH4LUIRDDg8ycOsZo5O7IxJ1xfGO3t6vmU8atJSA1L5VIncNW2OHgo+uvucFqRmxpPkB4M0DjGV1xJ1eRbGkpohraMFDtI+iUq5CJcdpfDHREUwvdOIjccqXMQqyFBXYeVSTBy0BmxiSeFDGOLCxfWDfX3HrYS8SmPPPsSKOlfkzOIBAWnovyqQISu/Mjpi0yVCJlHJ053mf+/lDAkHP3dUYAiLQyVrb/Ig0jiynWGH4sjGjviBaM5Psi3cRq0dAgNiaAb9Rin2FK+Hl5VUveyol23mCIsSBpzzXE5X6qtpxAJYLnq+PNdw6EDquvUkfK2KXBYocV3PZ9h9iqnyqq2IelXc0ZW1JkC6fbKYUbKN04oFkoVP53MxDoltag6Gun3ASbJVAKuSDqUnv9LstQNaNW+d4dvny0hgGYGjBlQI/f17jWhkebT+XVMcXX5uG3c0RAIfc9DpsDWObnwZ4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3077.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(136003)(39860400002)(8936002)(6486002)(2616005)(66946007)(86362001)(66476007)(956004)(66556008)(26005)(4326008)(53546011)(31686004)(186003)(6916009)(16526019)(478600001)(4744005)(83380400001)(16576012)(54906003)(5660300002)(6666004)(316002)(2906002)(8676002)(36756003)(31696002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZzNCRUZ2bjhTaUR5NVRraXE0RkhWb2dQdWdLM0QwTUIrSE8xTjBIcFhRaW1t?=
 =?utf-8?B?eHAzOTMzRWJGUjZnQjAwTk52SVNOMS9hSG5Qb3FXaHBUYjRKN1Q2Zm1XVWtP?=
 =?utf-8?B?ZFhrc21PdHRpUjlDVzJMZWgzbzNQUDVPRjc5dnAxbGVYQUUzTlB5MWhxSHpM?=
 =?utf-8?B?ZmtLTlNuMUljL09iZEZVbkM1d1d0T090M0dUZ09GakpSbnFleVFkbkVjb20v?=
 =?utf-8?B?bFlpOE5tdkJkcy9vZFpDRzlwcjdoQWpCWTRKbVVGUlJ4aWJyQjRDeEVNRmRE?=
 =?utf-8?B?V3pkWnFJVTk5OUtxVkNvVDA3Y3JDTmprV0lyYWpHUDU3RXpsYm04RFVNSWNC?=
 =?utf-8?B?dnphRG10L2lsNmlzbnozdDl6MWNFQVlLcEp6RStGMFE2K0UydmdGeHNVUmZm?=
 =?utf-8?B?bUt1Y3VSeUtkS09CWlBkbDFLUHJrQUgyNHdFV2lMZ2d3SHhNMW5lSkhpVUk5?=
 =?utf-8?B?T2RaSjlhYjFtZ3o0NGJDemNzb1lJeDNpN1BVcEltMEc2ZVVqbGttend5T0tC?=
 =?utf-8?B?QkxUSFRwUmwwNW9BNHpSb2crMjBLcHhmaGNMTnI4eDJmNms1c1dia2Nvb2Ev?=
 =?utf-8?B?bEk0Ulo1VFhVd0xqTjBJekhFdHhGM0dxUUhHdnowMTRYaHdrWFdKY2t4N2NO?=
 =?utf-8?B?dTNXNmJsY1BNUDFFVHMwa3QyUjBmUDhpcnhoMDJFM21hU1hKaGhsK0ZDWTdS?=
 =?utf-8?B?Y0pnNEcvdm1ZKzdzcU5xamtGWGZNQjRZUjJEbVNCRVZKY21nVmt1R1ErSEEz?=
 =?utf-8?B?R0ZWL3BJOFJlcFpzcWJJaVJjOWh4TnJYc3I5WFNEbVpLYTlxSGQ4Z2pWeVVH?=
 =?utf-8?B?RDV5YTlJNWNOMldRZFhzQXBqWHNJRVhXVDhJREYrL24rQ2NNVlNzZ0xDSlQx?=
 =?utf-8?B?VE15OG5jaWpIazhjUGg1aTZGdk1vbGJ3Z0Rjc2VqNUNjdDA3alFRa1NzWlgr?=
 =?utf-8?B?cGpEeTlvQXZnSWNxR3liQ2NnS3VxNWVtVm5WSE81d1N0N0lYd1MxUm1HUkMw?=
 =?utf-8?B?ZklrUFF4SlNEdkpvT3loMU5abmRIUEpkanZMMDlZVjgvclZkeDM2Q2dwdms1?=
 =?utf-8?B?ZUF0b0gyU0RWU05pNHAxS1hVSVZRc1h4YkFaNU1nNUs5cm51bEl4c1FCVzBh?=
 =?utf-8?B?T0NvNkswV3RUbFkzSlZWYU5nWHZ6Zk9Wc2E4enI1Q1hEK05NNUF6UVJaWkE1?=
 =?utf-8?B?UEdUYlY5QStaOXZ3bDRzekxrZVYzYVZwMFNNYUtWTENrVzZKRXMvcHV6Mk92?=
 =?utf-8?B?eUdlY1JseXlEbmFKeHNmZTYyQlNzT2RmOEsvbDV5R3p0bWFicTFqekE0cjJn?=
 =?utf-8?B?c0cwVm03Vk5MU2l1L2J2WE1lYXUvcHhJRG53TGxSQVNaSkxMbUxydUphTUpQ?=
 =?utf-8?B?bzBSTHJBZHFJcUFocUJIU1JFV0pxRlQrT1Zzck1jQlF0OUJZejZuazBGaTho?=
 =?utf-8?B?bGZ4NGlCNzZveG45anAvUjFZdW1YUkdSSnJZNE5uTWEvaGF4Q0VyVlREcjJN?=
 =?utf-8?B?RE5aQjVHRy9TZ25JZ2JRdXR2RFRWb29taFNBcWtiSnJKWTRCMU4vT1hhYU1H?=
 =?utf-8?B?UXhzZTFORG1rSTdVMGkzTHVYUEMyM1JId2Z0S3QzVzVEMHpTWWhNOTgwMHps?=
 =?utf-8?B?QlpuZytMYWRBOHRZWERtY0RDSTljdUlRYVB0cFdpT0g4R3BuSGwvNGVvc3ZP?=
 =?utf-8?B?T053bEFzaVpoL0hjdzJIMnNEaWtMOUpQK0NHaCtpMFRiMllrZ3RDL0g0eVJ3?=
 =?utf-8?Q?gbKo/uTSj4hgY508xwl3BQQDkVJ4cMGBe47zjlO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce0003a-780f-46c7-a17e-08d8cce1c9fc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3077.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 10:02:20.2859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vwq2BiQhRswdlqse1VZJEP65xfhNQ7mQFTEzJx6fAaKQZ1jc+3y3G3lIJ0Nv/OzjkdBdNoMGKzmoZO/PbPI9z9JtWVTB5O92JcUD6SNss1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4512
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=802 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/21 8:19 AM, Christoph Hellwig wrote:
> On Mon, Feb 08, 2021 at 07:26:25PM -0400, Jason Gunthorpe wrote:
>>>> page_mkclean() has some technique to make the notifier have the right
>>>> size without becoming entangled in the PTL locks..
>>>
>>> Right.  I guess it's because dax doesn't have "struct page*" on the
>>> back, so it
>>
>> It doesn't? I thought DAX cases did?
> 
> File system DAX has a struct page, device DAX does not.  Which means
> everything using iomap should have a page available, but i'm adding
> Dan as he should know the details :)
> 
Both fsdax and device-dax have struct page. It's the pmem block device
that doesn't.
