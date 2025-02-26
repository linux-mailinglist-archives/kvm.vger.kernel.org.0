Return-Path: <kvm+bounces-39280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A487A45EB1
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 13:23:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 901EF188B35C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 12:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5F8A21CA02;
	Wed, 26 Feb 2025 12:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UpyhS0QE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED639217670;
	Wed, 26 Feb 2025 12:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740572077; cv=none; b=hULJNiGVq6GiokTwVfEl5sRWOghZDKjAC/xD0UQk+XohiLtGCRtLv7SBKgHNggU9t9RGJR6vQnY8Drch2kfLErsfmkkSWMBixIoGjH5vLI/9JVTc04jhFLgjM2w86C8dQ/Xc/Mcva0yJAj64uUyGJOUYlOnHGXlQTp15AA6OmP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740572077; c=relaxed/simple;
	bh=dw8RKuOuBbZ3OPX6aFcUgjkDc62wOApZJuJQGPQATPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kaFLKr1EECycu1jFykDhCpy44lssaPwG7CkXCJjSld/C68MiNNSEnekF/SDel6AHdVXg3OrSkwNumJ2GzlqLE3uew5qEELxcPapa9ABfLujXNlz0st9BcmeuEnhxk9yqqUcqyFgRlUJB2fVskPMX1FZ3Qh/XpxFtdF0Ki5AzCEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UpyhS0QE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1ED0C4CED6;
	Wed, 26 Feb 2025 12:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740572076;
	bh=dw8RKuOuBbZ3OPX6aFcUgjkDc62wOApZJuJQGPQATPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UpyhS0QEk3eIXFiHz+SzhlE0ZxDDQs98OgkE/+hgERQ/tBnnHv+mqQgThnFQt+hZn
	 qDPQ95i6PfHtSk+jmcynOUJiZtIOJRcMF6EpTHxf8/LiAh/+5utWnLsCZNYI5CdJs5
	 JuyoictNbBaeopc+8eLDZvl0+yIdlQdUHa+B5UbdfzGvfQU5d0peUS86UXM5GfVYu7
	 6Zm+F98gJzj/E9KOCsdrwAlEPzLKrRvaxHHBpYMoCSbzTMjPHM5tPT8ddu6uajiN7Y
	 87BeCeLlzcprmLMQ+F5KX9gdW7jNdOvvGGSE68fwS5HJaqg0VeWsRQjFAxBBffBzST
	 RRhYFBXoVWXzw==
Date: Wed, 26 Feb 2025 13:14:32 +0100
From: Christian Brauner <brauner@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, "Michael S. Tsirkin" <mst@redhat.com>, 
	"Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
Message-ID: <20250226-portieren-staudamm-10823e224307@brauner>
References: <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
 <20250126142034.GA28135@redhat.com>
 <CAHk-=wiOSyfW3sgccrfVtanZGUSnjFidSbaP3tg9wapydb-u6g@mail.gmail.com>
 <20250126185354.GB28135@redhat.com>
 <CAHk-=wiA7wzJ9TLMbC6vfer+0F6S91XghxrdKGawO6uMQCfjtQ@mail.gmail.com>
 <20250127140947.GA22160@redhat.com>
 <CABgObfaar9uOx7t6vR0pqk6gU-yNOHX3=R1UHY4mbVwRX_wPkA@mail.gmail.com>
 <20250204-liehen-einmal-af13a3c66a61@brauner>
 <CABgObfaBizrwP6mh82U20Y0h9OwYa6OFn7QBspcGKak2r+5kUw@mail.gmail.com>
 <20250205-bauhof-fraktionslos-b1bedfe50db2@brauner>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250205-bauhof-fraktionslos-b1bedfe50db2@brauner>

On Wed, Feb 05, 2025 at 12:49:30PM +0100, Christian Brauner wrote:
> On Tue, Feb 04, 2025 at 05:05:06PM +0100, Paolo Bonzini wrote:
> > On Tue, Feb 4, 2025 at 3:19 PM Christian Brauner <brauner@kernel.org> wrote:
> > >
> > > On Mon, Jan 27, 2025 at 04:15:01PM +0100, Paolo Bonzini wrote:
> > > > On Mon, Jan 27, 2025 at 3:10 PM Oleg Nesterov <oleg@redhat.com> wrote:
> > > > > On 01/26, Linus Torvalds wrote:
> > > > > > On Sun, 26 Jan 2025 at 10:54, Oleg Nesterov <oleg@redhat.com> wrote:
> > > > > > >
> > > > > > > I don't think we even need to detect the /proc/self/ or /proc/self-thread/
> > > > > > > case, next_tid() can just check same_thread_group,
> > > > > >
> > > > > > That was my thinking yes.
> > > > > >
> > > > > > If we exclude them from /proc/*/task entirely, I'd worry that it would
> > > > > > hide it from some management tool and be used for nefarious purposes
> > > > >
> > > > > Agreed,
> > > > >
> > > > > > (even if they then show up elsewhere that the tool wouldn't look at).
> > > > >
> > > > > Even if we move them from /proc/*/task to /proc ?
> > > >
> > > > Indeed---as long as they show up somewhere, it's not worse than it
> > > > used to be. The reason why I'd prefer them to stay in /proc/*/task is
> > > > that moving them away at least partly negates the benefits of the
> > > > "workers are children of the starter" model. For example it
> > > > complicates measuring their cost within the process that runs the VM.
> > > > Maybe it's more of a romantic thing than a real practical issue,
> > > > because in the real world resource accounting for VMs is done via
> > > > cgroups. But unlike the lazy creation in KVM, which is overall pretty
> > > > self-contained, I am afraid the ugliness in procfs would be much worse
> > > > compared to the benefit, if there's a benefit at all.
> > > >
> > > > > Perhaps, I honestly do not know what will/can confuse userspace more.
> > > >
> > > > At the very least, marking workers as "Kthread: 1" makes sense and
> 
> You mean in /proc/<pid>/status? Yeah, we can do that. This expands the
> definition of Kthread a bit. It would now mean anything that the kernel
> spawned for userspace. But that is probably fine.
> 
> But it won't help with the problem of just checking /proc/<pid>/task/ to
> figure out whether the caller is single-threaded or not. If the caller
> has more than 1 entry in there they need to walk through all of them and
> parse through /proc/<pid>/status to discount them if they're kernel
> threads.
> 
> > > > should not cause too much confusion. I wouldn't go beyond that unless
> > > > we get more reports of similar issues, and I'm not even sure how
> > > > common it is for userspace libraries to check for single-threadedness.
> > >
> > > Sorry, just saw this thread now.
> > >
> > > What if we did what Linus suggests and hide (odd) user workers from
> > > /proc/<pid>/task/* but also added /proc/<pid>/workers/*. The latter
> > > would only list the workers that got spawned by the kernel for that
> > > particular task? This would acknowledge their somewhat special status
> > > and allow userspace to still detect them as "Hey, I didn't actually
> > > spawn those, they got shoved into my workload by the kernel for me.".
> > 
> > Wouldn't the workers then disappear completely from ps, top or other
> > tools that look at /proc/$PID/task? That seems a bit too underhanded
> > towards userspace...
> 
> So maybe, but then there's also the possibility to do:
> 
> - Have /proc/<pid>/status list all tasks.
> - Have /proc/<pid>/worker only list user workers spawned by the kernel for userspace.
> 
> count(/proc/<pid>/status) - count(/proc/<pid>/workers) == 1 => (userspace) single threaded
> 
> My wider point is that I would prefer we add something that is
> consistent and doesn't have to give the caller a different view than a
> foreign task. I think that will just create confusion in the long run.

So what I had in mind was (quickly sketched) the rough draft below. This
will unconditionally skip PF_USER_WORKER tasks in /proc/<pid>/task and
will only list them in /proc/<pid>/worker.

 fs/proc/base.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 116 insertions(+), 6 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index cd89e956c322..60e6b2cea259 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3315,10 +3315,13 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
  * Thread groups
  */
 static const struct file_operations proc_task_operations;
+static const struct file_operations proc_worker_operations;
 static const struct inode_operations proc_task_inode_operations;
+static const struct inode_operations proc_worker_inode_operations;
 
 static const struct pid_entry tgid_base_stuff[] = {
 	DIR("task",       S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
+	DIR("worker",     S_IRUGO|S_IXUGO, proc_worker_inode_operations, proc_worker_operations),
 	DIR("fd",         S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
 	DIR("map_files",  S_IRUSR|S_IXUSR, proc_map_files_inode_operations, proc_map_files_operations),
 	DIR("fdinfo",     S_IRUGO|S_IXUGO, proc_fdinfo_inode_operations, proc_fdinfo_operations),
@@ -3835,11 +3838,14 @@ static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry
 
 	fs_info = proc_sb_info(dentry->d_sb);
 	ns = fs_info->pid_ns;
-	rcu_read_lock();
-	task = find_task_by_pid_ns(tid, ns);
-	if (task)
-		get_task_struct(task);
-	rcu_read_unlock();
+	scoped_guard(rcu) {
+		task = find_task_by_pid_ns(tid, ns);
+		if (task) {
+			if (task->flags & PF_USER_WORKER)
+				goto out;
+			get_task_struct(task);
+		}
+	}
 	if (!task)
 		goto out;
 	if (!same_thread_group(leader, task))
@@ -3949,7 +3955,7 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 	tid = (int)(intptr_t)file->private_data;
 	file->private_data = NULL;
 	for (task = first_tid(proc_pid(inode), tid, ctx->pos - 2, ns);
-	     task;
+	     task && !(task->flags & PF_USER_WORKER);
 	     task = next_tid(task), ctx->pos++) {
 		char name[10 + 1];
 		unsigned int len;
@@ -3987,6 +3993,97 @@ static int proc_task_getattr(struct mnt_idmap *idmap,
 	return 0;
 }
 
+static struct dentry *
+proc_worker_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
+{
+	struct task_struct *task;
+	struct task_struct *leader = get_proc_task(dir);
+	unsigned tid;
+	struct proc_fs_info *fs_info;
+	struct pid_namespace *ns;
+	struct dentry *result = ERR_PTR(-ENOENT);
+
+	if (!leader)
+		goto out_no_task;
+
+	tid = name_to_int(&dentry->d_name);
+	if (tid == ~0U)
+		goto out;
+
+	fs_info = proc_sb_info(dentry->d_sb);
+	ns = fs_info->pid_ns;
+	scoped_guard(rcu) {
+		task = find_task_by_pid_ns(tid, ns);
+		if (task) {
+			if (!(task->flags & PF_USER_WORKER))
+				goto out;
+			get_task_struct(task);
+		}
+	}
+	if (!task)
+		goto out;
+	if (!same_thread_group(leader, task))
+		goto out_drop_task;
+
+	result = proc_task_instantiate(dentry, task, NULL);
+out_drop_task:
+	put_task_struct(task);
+out:
+	put_task_struct(leader);
+out_no_task:
+	return result;
+}
+
+static int proc_worker_getattr(struct mnt_idmap *idmap, const struct path *path,
+			       struct kstat *stat, u32 request_mask,
+			       unsigned int query_flags)
+{
+	generic_fillattr(&nop_mnt_idmap, request_mask, d_inode(path->dentry), stat);
+	return 0;
+}
+
+static int proc_worker_readdir(struct file *file, struct dir_context *ctx)
+{
+	struct inode *inode = file_inode(file);
+	struct task_struct *task;
+	struct pid_namespace *ns;
+	int tid;
+
+	if (proc_inode_is_dead(inode))
+		return -ENOENT;
+
+	if (!dir_emit_dots(file, ctx))
+		return 0;
+
+	/* We cache the tgid value that the last readdir call couldn't
+	 * return and lseek resets it to 0.
+	 */
+	ns = proc_pid_ns(inode->i_sb);
+	tid = (int)(intptr_t)file->private_data;
+	file->private_data = NULL;
+	for (task = first_tid(proc_pid(inode), tid, ctx->pos - 2, ns);
+	     task && (task->flags & PF_USER_WORKER);
+	     task = next_tid(task), ctx->pos++) {
+		char name[10 + 1];
+		unsigned int len;
+
+		tid = task_pid_nr_ns(task, ns);
+		if (!tid)
+			continue;	/* The task has just exited. */
+		len = snprintf(name, sizeof(name), "%u", tid);
+		if (!proc_fill_cache(file, ctx, name, len,
+				proc_task_instantiate, task, NULL)) {
+			/* returning this tgid failed, save it as the first
+			 * pid for the next readir call */
+			file->private_data = (void *)(intptr_t)tid;
+			put_task_struct(task);
+			break;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * proc_task_readdir() set @file->private_data to a positive integer
  * value, so casting that to u64 is safe. generic_llseek_cookie() will
@@ -4005,6 +4102,19 @@ static loff_t proc_dir_llseek(struct file *file, loff_t offset, int whence)
 	return off;
 }
 
+static const struct inode_operations proc_worker_inode_operations = {
+	.lookup		= proc_worker_lookup,
+	.getattr	= proc_worker_getattr,
+	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
+};
+
+static const struct file_operations proc_worker_operations = {
+	.read		= generic_read_dir,
+	.iterate_shared	= proc_worker_readdir,
+	.llseek		= proc_dir_llseek,
+};
+
 static const struct inode_operations proc_task_inode_operations = {
 	.lookup		= proc_task_lookup,
 	.getattr	= proc_task_getattr,
-- 
2.47.2


