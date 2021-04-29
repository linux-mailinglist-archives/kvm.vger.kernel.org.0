Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F079036E5D3
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 09:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239210AbhD2HWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 03:22:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49610 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237274AbhD2HV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 03:21:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T7JwTt110490;
        Thu, 29 Apr 2021 07:20:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=ldwcYv7Gb6WISZ0ZVkpWcd8IbB24cEiFnDDT58tajC8=;
 b=xwr5GA5izRjF+3Bj7R5hQdoQyzVNeN5tab4ongYmCJiWm0H0sqwXtzNbCcYI/WP4R3qh
 dhikH47GImWpJOoVRPOpYeVCs5GhXfWZDWuLXlUZPkvhyvta9QGciUt3RW1B88uJEnyA
 3OvRkcRFY9dSvwdIbWtWqFy3IENtCdXYguLUGZCilFhYk7wWalrnRqs+YbbMHNdVWHKg
 8Z32H7ZccdznYpv1l9XypuGY5TgvLVHLVcvjgHibK25nK37e6Hnevr5m1gytqJ2i221S
 Cs9XkpOLWcSEaGXMAaNVywTHYP69Fd5IAD6U6s/w1+TBdi4xBGUgr5nWrNtP1zZ/9RZO Tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 385aft38sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 07:20:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T7EolU105926;
        Thu, 29 Apr 2021 07:20:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3874d350c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 07:20:23 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 13T7KM45126683;
        Thu, 29 Apr 2021 07:20:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3874d350b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 07:20:22 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 13T7KL8c009287;
        Thu, 29 Apr 2021 07:20:21 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Apr 2021 00:20:20 -0700
Date:   Thu, 29 Apr 2021 10:20:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     brijesh.singh@amd.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Message-ID: <YIpeKpSB7Wqkqn9f@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-GUID: lPBsoagLFSmVwukdju_ZoeQAeue1UJNc
X-Proofpoint-ORIG-GUID: lPBsoagLFSmVwukdju_ZoeQAeue1UJNc
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1011 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104290053
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Brijesh Singh,

The patch d3d1af85e2c7: "KVM: SVM: Add KVM_SEND_UPDATE_DATA command"
from Apr 15, 2021, leads to the following static checker warning:

arch/x86/kvm/svm/sev.c:1268 sev_send_update_data() warn: 'guest_page' is an error pointer or valid
arch/x86/kvm/svm/sev.c:1316 sev_send_update_data() warn: maybe return -EFAULT instead of the bytes remaining?
arch/x86/kvm/svm/sev.c:1462 sev_receive_update_data() warn: 'guest_page' is an error pointer or valid

arch/x86/kvm/svm/sev.c
  1261          offset = params.guest_uaddr & (PAGE_SIZE - 1);
  1262          if ((params.guest_len + offset > PAGE_SIZE))
  1263                  return -EINVAL;
  1264  
  1265          /* Pin guest memory */
  1266          guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
  1267                                      PAGE_SIZE, &n, 0);
  1268          if (!guest_page)

The sev_pin_memory() function returns error pointers, not NULL.

  1269                  return -EFAULT;
  1270  
  1271          /* allocate memory for header and transport buffer */
  1272          ret = -ENOMEM;
  1273          hdr = kmalloc(params.hdr_len, GFP_KERNEL_ACCOUNT);
  1274          if (!hdr)
  1275                  goto e_unpin;
  1276  
  1277          trans_data = kmalloc(params.trans_len, GFP_KERNEL_ACCOUNT);
  1278          if (!trans_data)
  1279                  goto e_free_hdr;
  1280  
  1281          memset(&data, 0, sizeof(data));
  1282          data.hdr_address = __psp_pa(hdr);
  1283          data.hdr_len = params.hdr_len;
  1284          data.trans_address = __psp_pa(trans_data);
  1285          data.trans_len = params.trans_len;
  1286  
  1287          /* The SEND_UPDATE_DATA command requires C-bit to be always set. */
  1288          data.guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) + offset;
  1289          data.guest_address |= sev_me_mask;
  1290          data.guest_len = params.guest_len;
  1291          data.handle = sev->handle;
  1292  
  1293          ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, &data, &argp->error);
  1294  
  1295          if (ret)
  1296                  goto e_free_trans_data;
  1297  
  1298          /* copy transport buffer to user space */
  1299          if (copy_to_user((void __user *)(uintptr_t)params.trans_uaddr,
  1300                           trans_data, params.trans_len)) {
  1301                  ret = -EFAULT;
  1302                  goto e_free_trans_data;
  1303          }
  1304  
  1305          /* Copy packet header to userspace. */
  1306          ret = copy_to_user((void __user *)(uintptr_t)params.hdr_uaddr, hdr,
  1307                                  params.hdr_len);

This should be:
		 if (copy_to_user(...))
			ret = -EFAULT;

  1308  
  1309  e_free_trans_data:
  1310          kfree(trans_data);
  1311  e_free_hdr:
  1312          kfree(hdr);
  1313  e_unpin:
  1314          sev_unpin_memory(kvm, guest_page, n);
  1315  
  1316          return ret;
  1317  }

[ snip ]

  1456          data.trans_len = params.trans_len;
  1457  
  1458          /* Pin guest memory */
  1459          ret = -EFAULT;
  1460          guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
  1461                                      PAGE_SIZE, &n, 0);
  1462          if (!guest_page)

IS_ERR(guest_page) here as well.

  1463                  goto e_free_trans;
  1464  
  1465          /* The RECEIVE_UPDATE_DATA command requires C-bit to be always set. */
  1466          data.guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) + offset;
  1467          data.guest_address |= sev_me_mask;
  1468          data.guest_len = params.guest_len;
  1469          data.handle = sev->handle;
  1470  

regards,
dan carpenter
