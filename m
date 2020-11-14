Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A24E2B296E
	for <lists+kvm@lfdr.de>; Sat, 14 Nov 2020 01:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgKNAAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 19:00:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34552 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgKNAAd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 19:00:33 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADNXUgl102002;
        Fri, 13 Nov 2020 19:00:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=KbDra3b4iMFEa4HfdicQdCImsu4ywafeeEhug4M4Rcg=;
 b=lFSc3YW6DPz5SFos/vuyX/ollqiiXHpeexQ5wPA31EBkS7xBYbHF84YcefX07BaPta1X
 6E2hOJ0wrodtLfLDk3lDMdvLIMgZDM9cpeZEnYMy3tY4EzIG8pANKvS4MWxFm7ECzjGZ
 Y1oNrUh0NucCgJgpW7kBh6zucIDFgXsKsc0a/W6LvHkZsS/lE2Yz6OH230iNsGXZpXGO
 om20eVNCsvaxeZN0bCN3kbg4YH3iVWfND+eOuaRJ8j1wUegMHS8eVzSSoUOrI0dXekKj
 Y78Xv1eI7UScRKHrppZMGNpLq/9nXoz8r6lBnywGVxoQsCXRgjQWgQ5N3oxeSLxspsWv fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34sxt519wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 19:00:28 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ADNkNaf146020;
        Fri, 13 Nov 2020 19:00:28 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34sxt519v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 19:00:28 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ADNuYBA005583;
        Sat, 14 Nov 2020 00:00:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 34nk78q789-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 00:00:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AE00NSW5964370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 00:00:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2DFE42041;
        Sat, 14 Nov 2020 00:00:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3032D4204F;
        Sat, 14 Nov 2020 00:00:22 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.46.164])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sat, 14 Nov 2020 00:00:22 +0000 (GMT)
Date:   Sat, 14 Nov 2020 01:00:20 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 04/14] s390/zcrypt: driver callback to indicate
 resource in use
Message-ID: <20201114010020.381277c2.pasic@linux.ibm.com>
In-Reply-To: <dcdb9c78-daf8-1f25-f59a-903f0db96ada@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-5-akrowiak@linux.ibm.com>
        <42f3f4f9-6263-cb1e-d882-30b62236a594@linux.ibm.com>
        <dcdb9c78-daf8-1f25-f59a-903f0db96ada@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_21:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 adultscore=0 impostorscore=0
 mlxlogscore=999 clxscore=1015 suspectscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130151
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Nov 2020 16:30:31 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> We will be using the mutex_trylock() function in our sysfs 
> assignment
> interfaces which make the call to the AP bus to check permissions (which 
> also
> locks ap_perms). If the mutex_trylock() fails, we return from the assignment
> function with -EBUSY. This should resolve that potential deadlock issue.

It resolves the deadlock issue only if in_use() is also doing
mutex_trylock(), but the if in_use doesn't take the lock it
needs to back off (and so does it's client code) i.e. a boolean as
return value won't do.

Regards,
Halil
