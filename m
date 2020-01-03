Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2846512F838
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2020 13:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgACMbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jan 2020 07:31:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41406 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgACMbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jan 2020 07:31:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003CSxKW111446;
        Fri, 3 Jan 2020 12:31:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=b3uRmQvNfEosDDjOkW8sRh5UcyCobfd0n7/rf6Tc50w=;
 b=L6k+3As/gutJ1nFXFNf51TfYYr4/IWOK5zSdB/AtXuvzPsMXxeoUeZUwxuKC8APMBDav
 XkNZMhBqMaeqiODQS0N6h19Lp+Y/bwD12NCwSREB3PLJgCS5iOndUcNJGMxC4itHIPHO
 pqEIp1vAPFlDyx3cLAupwZ3OxkuPTR8GtCSSFp2lKcnyE7l2sK8T2823+1e7WSupgIkD
 ExSJOHcwC3FxuqUwhcggphRSRu7JRhxTJd/jm4N8qe5OQ2+2FkQiltqAj+kE8A2gMtmG
 6Oi48LSuDov6CCqf/MX5cOkDd/I8fNHEKKOMCZ61d8588vB0XPFmwjC7NjhPmobl7ofP pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2x5xftv8k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 12:31:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003CS2BE076479;
        Fri, 3 Jan 2020 12:31:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xa5fg8es7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 12:31:13 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 003CV7mt008844;
        Fri, 3 Jan 2020 12:31:08 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 04:31:06 -0800
Date:   Fri, 3 Jan 2020 15:31:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     kvm@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        openrisc@lists.librecores.org
Subject: Re: [PATCH 0/4] use mmgrab
Message-ID: <20200103123059.GI3911@kadam>
References: <1577634178-22530-1-git-send-email-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1577634178-22530-1-git-send-email-Julia.Lawall@inria.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=698
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=761 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030119
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 29, 2019 at 04:42:54PM +0100, Julia Lawall wrote:
> Mmgrab was introduced in commit f1f1007644ff ("mm: add new mmgrab()
> helper") and most of the kernel was updated to use it. Update a few
> remaining files.

I wonder if there is an automatic way to generate these kind of
Coccinelle scripts which use inlines instead of open coding.  Like maybe
make a list of one line functions, and then auto generate a recipe.  Or
the mmgrab() function could have multiple lines if the first few were
just sanity checks for NULL or something...

regards,
dan carpenter
